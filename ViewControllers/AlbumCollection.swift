//
//  AlbumCollection.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 14/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class AlbumCollection: UIViewController {

    var apiClient = APIClient()
    var albums: [Album]
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

    init(albums: [Album], artist: Artist) {
        self.artist = artist
        self.albums = albums
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.item]



        SpinnerView.shared.showProgressView()
        apiClient.getTracks(fromAlbum: "\(album.id)") { albumDetail in

            let queue = OperationQueue()
            var trackList = [TrackDetail]()
            var coverImage: UIImage?


            let operation1 = BlockOperation {
                DispatchQueue.main.async {
                    let group = DispatchGroup()
                    group.enter()
                    self.apiClient.detailedTracks(fromAlbum: albumDetail) { tracks in
                        trackList = tracks
                        group.leave()
                    }
                    group.wait()
                }
            }

            let operation2 = BlockOperation {
                let group = DispatchGroup()
                group.enter()

                self.apiClient.getImage(url: album.cover) { image in
                    coverImage = image
                    group.leave()
                }

                group.wait()
            }


            let completionOperation = BlockOperation {

                let backup = UIImage(named: "PlaceholderImage")!.withTintColor(.systemPink)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(TracksTableView(album: albumDetail, tracks: trackList, coverImage: coverImage ?? backup), animated: true)
                    SpinnerView.shared.hideProgressView()
                }
            }

            completionOperation.addDependency(operation1)
            completionOperation.addDependency(operation2)

            queue.addOperations([operation1, operation2, completionOperation], waitUntilFinished: true)
        }
    }
}
