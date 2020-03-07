//
//  AlbumCollection.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 14/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class AlbumCollection: UIViewController, AlertDisplayer {


    let albumClient: AlbumProvider
    let imageClient: ImageProvider
    var albums: [AlbumThinned]
    var artist: Artist

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(AlbumItem.self, forCellWithReuseIdentifier: "albumItem")
        view.addSubview(cv)
        cv.delaysContentTouches = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        title = artist.name
        view.backgroundColor = .systemBackground
    }

    init(albums: [AlbumThinned], artist: Artist, albumClient: AlbumProvider, imageClient: ImageProvider ) {
        self.artist = artist
        self.albums = albums
        self.albumClient = albumClient
        self.imageClient = imageClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension AlbumCollection: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumItem", for: indexPath) as! AlbumItem
        cell.album = albums[indexPath.item]
        cell.artist = artist
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let albumItem = cell as? AlbumItem else { return }
        guard let imageUrl = albumItem.album?.cover else { return }
        imageClient.getImage(url: imageUrl) { [displayGenericError] result in
            switch result {
            case .failure:
                displayGenericError()
            case .success(let image):
                albumItem.setImage(image: image)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.item]

        SpinnerView.shared.showProgressView()

        albumClient.getAlbumData(fromAlbum: album) { [displayGenericError] result in
            switch result {
            case .failure:
                displayGenericError()
            case .success(let album):
                self.imageClient.getImage(url: album.cover) { [displayGenericError] result in
                    switch result {
                    case .failure:
                        displayGenericError()
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(TracksTableView(album: album, coverImage: image), animated: true)
                            SpinnerView.shared.hideProgressView()
                        }
                    }
                }
            }
        }
    }
}
