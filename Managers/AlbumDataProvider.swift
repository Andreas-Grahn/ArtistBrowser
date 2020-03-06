//
//  AlbumDataProvider.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

protocol AlbumProvider {
    func getAlbums(searchQuery: String, completion: @escaping ([AlbumThinned]) -> ())
    func getAlbumData(fromAlbum album: AlbumThinned, completion: @escaping (Album) -> ())
    func getAlbum(fromArtist id: String, completion: @escaping ([AlbumThinned]) -> ())
}

class AlbumDataProvider: AlbumProvider {
    private let httpClient = HTTPClient.shared

    func getAlbums(searchQuery: String, completion: @escaping ([AlbumThinned]) -> ()) {
        if var urlComponents = URLComponents(string: "https://api.deezer.com/search/album") {
            urlComponents.query = "q=\(searchQuery)"
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            httpClient.getData(request: request) { data in
                do {
                    let albumData = try JSONDecoder().decode([AlbumThinned].self, from: data)
                    completion(albumData)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getAlbum(fromArtist id: String, completion: @escaping ([AlbumThinned]) -> ()) {

        if let urlComponents = URLComponents(string: "https://api.deezer.com/artist/\(id)/albums") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            httpClient.getData(request: request) { data in
                do {
                    let albums = try JSONDecoder().decode(AlbumThinnedData.self, from: data)
                    completion(albums.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getAlbumData(fromAlbum albumThinned: AlbumThinned, completion: @escaping (Album) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/album/\(albumThinned.id)") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            httpClient.getData(request: request) { data in
                do {
                    var album = try JSONDecoder().decode(Album.self, from: data)
                    self.getTracks(withIds: album.tracksIds.data.map({$0.id})) { tracks in
                        album.tracks = tracks
                        completion(album)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

    private func getTracks(withIds ids: [Int], completion: @escaping ([TrackDetail]) -> ()) {
        let queue = OperationQueue()
        var list = [TrackDetail]()
        let completionOperation = BlockOperation {
            list.sort {
                ($0.disk_number, $0.track_position) < ($1.disk_number, $1.track_position)
            }
            completion(list)
        }

        for id in ids {
            let operation = BlockOperation {
                let group = DispatchGroup()
                group.enter()

                self.getTrack(withId: "\(id)") { detailedTrack in
                    list.append(detailedTrack)
                    group.leave()
                }
                group.wait()
            }

            queue.addOperation(operation)
            completionOperation.addDependency(operation)
        }
        queue.addOperation(completionOperation)
    }

    private func getTrack(withId id: String, completion: @escaping (TrackDetail) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/track/\(id)") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)
            httpClient.getData(request: request) { data in
                do {
                    let track = try JSONDecoder().decode(TrackDetail.self, from: data)
                    completion(track)
                } catch {
                    print(error)
                }
            }
        }
    }
}
