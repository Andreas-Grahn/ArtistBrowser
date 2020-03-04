//
//  APIClient.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 11/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation
import UIKit

final class APIClient: NSObject, URLSessionDelegate{

    lazy var defaultSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    var dataTask: URLSessionDataTask?
    let cache = URLCache.shared

    func getImage(url: String, completion: @escaping ((UIImage) -> Void)) {
        guard let imageURL = URL(string: url) else {
            return
        }

        let request = URLRequest(url: imageURL)

        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                completion(image)
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        completion(image)
                    }
                }.resume()
            }
        }
    }

    func getData(request: URLRequest, completion: @escaping ((Data) -> Void)) {

        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.cache.cachedResponse(for: request)?.data{
                completion(data)
            } else {
                self.defaultSession.dataTask(with: request) { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        completion(data)
                    }
                }.resume()
            }
        }
    }

    func getTopAlbums(completion: @escaping ([Album]) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/chart/0/albums") {
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)

            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(DataAlbum.self, from: data)
                    completion(a.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getTopArtists(completion: @escaping ([Artist]) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/chart/0/artists") {
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)
            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(DataArtist.self, from: data)
                    completion(a.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getArtist(searchQuery: String, completion: @escaping ([Artist]) -> ()) {
        if var urlComponents = URLComponents(string: "https://api.deezer.com/search/artist") {
            urlComponents.query = "q=\(searchQuery)"
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)

            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(DataArtist.self, from: data)
                    completion(a.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getAlbum(searchQuery: String, completion: @escaping ([Album]) -> ()) {
        if var urlComponents = URLComponents(string: "https://api.deezer.com/search/album") {
            urlComponents.query = "q=\(searchQuery)"
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(DataAlbum.self, from: data)
                    completion(a.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getTracks(fromAlbum id: String, completion: @escaping (AlbumDetail) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/album/\(id)") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(AlbumDetail.self, from: data)
                    completion(a)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getTrack(withId id: String, completion: @escaping (TrackDetail) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/track/\(id)") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)
            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(TrackDetail.self, from: data)
                    completion(a)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getAlbum(fromArtist id: String, completion: @escaping ([Album]) -> ()) {

        if let urlComponents = URLComponents(string: "https://api.deezer.com/artist/\(id)/albums") {
            guard let url = urlComponents.url else {
                return
            }
            let request = URLRequest(url: url)

            getData(request: request) { data in
                do {
                    let a = try JSONDecoder().decode(DataAlbum.self, from: data)
                    completion(a.data)
                } catch {
                    print(error)
                }
            }
        }
    }

    func detailedTracks(fromAlbum album: AlbumDetail, completion: @escaping ([TrackDetail]) -> ()) {
        let queue = OperationQueue()
        var list = [TrackDetail]()
        let completionOperation = BlockOperation {

            list.sort {
                ($0.disk_number, $0.track_position) < ($1.disk_number, $1.track_position)
            }
            completion(list)
        }

        for track in album.tracks.data {
            let operation = BlockOperation {
                let group = DispatchGroup()
                group.enter()

                self.getTrack(withId: "\(track.id)") { detailedTrack in
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
}
