//
//  HTTPClient.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

public final class HTTPClient {
    public static let shared = HTTPClient()

    private lazy var defaultSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    private let cache = URLCache.shared

    func getData(request: URLRequest, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.cache.cachedResponse(for: request)?.data{
                completion(.success(data))
            } else {
                self.defaultSession.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(.failure(.unknown(error)))
                    }
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500

                    if let data = data, let response = response, statusCode < 300 {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        completion(.success(data))
                    } else {
                        completion(.failure(.network(statusCode)))
                    }
                }.resume()
            }
        }
    }
}
