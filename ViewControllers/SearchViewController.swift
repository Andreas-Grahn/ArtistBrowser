//
//  ViewController.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 10/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let artistClient: ArtistProvider = ArtistDataProvider()
    let albumClient: AlbumProvider = AlbumDataProvider()
    let imageClient: ImageProvider = ImageDataProvider()

    var artistList = [Artist]()
    var topArtist = [Artist]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delaysContentTouches = false
        view.addSubview(tableView)
        return tableView
    }()

    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        return sc
    }()

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    private func getTopArtists() {
        artistClient.getTopArtists { [updateTable] artists in
            self.topArtist = artists
            updateTable(artists)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top artists"
        view.backgroundColor = .systemBackground

        tableView.register(ArtistCell.self, forCellReuseIdentifier: "artistCellId")

        setupSearchController()
        setupConstraints()
        getTopArtists()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for artist"
        self.navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCellId", for: indexPath) as! ArtistCell
        cell.artist = artistList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let artistCell = cell as? ArtistCell else { return }
        imageClient.getImage(url: artistList[indexPath.row].picture) { image in
            artistCell.setImage(image: image)
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artistList[indexPath.row]
        SpinnerView.shared.showProgressView()
        albumClient.getAlbum(fromArtist: "\(artist.id)") { (albums: [AlbumThinned]) in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(AlbumCollection(albums: albums, artist: artist, albumClient: AlbumDataProvider(), imageClient: ImageDataProvider()), animated: true)
                SpinnerView.shared.hideProgressView()
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let searchQuery = searchBar.text else { return }

        if searchQuery == "" {
            updateTable(artists: topArtist)
        } else {
            artistClient.getArtist(searchQuery: searchQuery) { [updateTable] (artists: [Artist]) in
                updateTable(artists)
            }
        }
    }

    private func updateTable(artists: [Artist]) {
        DispatchQueue.main.async {
            self.artistList.removeAll()
            self.artistList = artists
            self.tableView.reloadData()
        }
    }

}

