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
    private let responseHandler = ResponseHandler()

    private lazy var defaultSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    private let cache = URLCache.shared

    func getData(request: URLRequest, completion: @escaping ((Result<Data, APIError>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [responseHandler] in
            if let data = self.cache.cachedResponse(for: request)?.data{
                completion(.success(data))
            } else {
                self.defaultSession.dataTask(with: request) { [responseHandler] (data, response, error) in
                    do {
                        try responseHandler.handle(data: data, response: response, error: error)
                        let data = try responseHandler.read(data: data)
                        completion(.success(data))
                    } catch let error as APIError {
                        completion(.failure(error))
                    } catch {
                        let apiError = APIError.device(error)
                        completion(.failure(apiError))
                    }
                }.resume()
            }
        }
    }
}
