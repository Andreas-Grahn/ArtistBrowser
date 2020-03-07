//
//  ArtistDataProvider.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

protocol ArtistProvider {
    func getTopArtists(completion: @escaping (Result<[Artist], APIError>) -> ())
    func getArtist(searchQuery: String, completion: @escaping (Result<[Artist], APIError>) -> ())
}

class ArtistDataProvider: ArtistProvider {
    
    private let httpClient = HTTPClient.shared

    func getTopArtists(completion: @escaping (Result<[Artist], APIError>) -> ()) {
        if let urlComponents = URLComponents(string: "https://api.deezer.com/chart/0/artists") {
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)
            httpClient.getData(request: request) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(.unknown(error)))
                case .success(let data):
                    do {
                        let artistData = try JSONDecoder().decode(APIArtist.self, from: data)
                        completion(.success(artistData.data))
                    } catch {
                        completion(.failure(.decoding))
                    }
                }
            }
        }
    }

    func getArtist(searchQuery: String, completion: @escaping (Result<[Artist], APIError>) -> ()) {
        if var urlComponents = URLComponents(string: "https://api.deezer.com/search/artist") {
            urlComponents.query = "q=\(searchQuery)"
            guard let url = urlComponents.url else {
                return
            }

            let request = URLRequest(url: url)
            httpClient.getData(request: request) { result in

                switch result {
                case .failure(let error):
                    completion(.failure(.unknown(error)))
                case .success(let data):
                    do {
                        let artistData = try JSONDecoder().decode(APIArtist.self, from: data)
                        completion(.success(artistData.data))
                    } catch {
                        completion(.failure(.decoding))
                    }
                }
            }
        }
    }
}
