//
//  ArtistDataProvider.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

protocol ArtistProvider {
    func getTopArtists(completion: @escaping ([Artist]) -> ())
    func getArtist(searchQuery: String, completion: @escaping ([Artist]) -> ())
}

class ArtistDataProvider: ArtistProvider {

    private let httpClient = HTTPClient.shared

    func getTopArtists(completion: @escaping ([Artist]) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/chart/0/artists") {
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)
            httpClient.getData(request: request) { data in
                do {
                    let artistData = try JSONDecoder().decode(APIArtist.self, from: data)
                    completion(artistData.data)
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
            httpClient.getData(request: request) { data in
                do {
                    let artistData = try JSONDecoder().decode(APIArtist.self, from: data)
                    completion(artistData.data)
                } catch {
                    print(error)
                }
            }
        }
    }
}
