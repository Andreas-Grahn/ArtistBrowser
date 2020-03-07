//
//  ImageDataProvider.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func getImage(url: String, completion: @escaping ((Result<UIImage, APIError>) -> Void))
}

public class ImageDataProvider: ImageProvider {
    private let httpClient = HTTPClient.shared

    func getImage(url: String, completion: @escaping ((Result<UIImage, APIError>) -> Void)) {
        guard let imageURL = URL(string: url) else {
            return
        }

        let request = URLRequest(url: imageURL)
        httpClient.getData(request: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(.unknown(error)))
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.decoding))
                }
            }
        }
    }
}
