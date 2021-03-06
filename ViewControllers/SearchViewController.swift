//
//  ViewController.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 10/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, AlertDisplayer {

    private let artistClient: ArtistProvider = ArtistDataProvider()
    private let albumClient: AlbumProvider = AlbumDataProvider()
    private let imageClient: ImageProvider = ImageDataProvider()

    private var artistList = [Artist]()
    private var topArtist = [Artist]()

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

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        return sc
    }()

    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    private func getTopArtists() {
        artistClient.getTopArtists { [updateTable, displayGenericError] result in
            switch result {
            case .failure:
                displayGenericError()
            case .success(let artists):
                self.topArtist = artists
                updateTable(artists)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("TOP_ARTISTS", comment: "Most popular artists")
        view.backgroundColor = .systemBackground

        tableView.register(ArtistCell.self, forCellReuseIdentifier: ArtistCell.getReuseId())

        setupSearchController()
        setupConstraints()
        getTopArtists()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("SEARCH_FOR_ARTIST", comment: "Search for artist")
        self.navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
    }

    private func setupConstraints() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCell.getReuseId(), for: indexPath) as! ArtistCell
        cell.artistLabel.text = artistList[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let artistCell = cell as? ArtistCell else { return }
        imageClient.getImage(url: artistList[indexPath.row].picture) { [displayGenericError] result in
            switch result {
            case .failure:
                displayGenericError()
            case .success(let image):
                artistCell.setImage(image: image)
            }
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artistList[indexPath.row]
        SpinnerView.shared.showProgressView()
        albumClient.getAlbum(fromArtist: "\(artist.id)") { [displayGenericError] result in

            switch result {
            case .failure:
                displayGenericError()
            case .success(let albums):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AlbumCollection(albums: albums, artist: artist, albumClient: AlbumDataProvider(), imageClient: ImageDataProvider()), animated: true)
                    SpinnerView.shared.hideProgressView()
                }
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
            artistClient.getArtist(searchQuery: searchQuery) { [updateTable, displayGenericError] result in
                switch result {
                case .failure:
                    displayGenericError()
                case .success(let artists):
                    updateTable(artists)
                }
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

