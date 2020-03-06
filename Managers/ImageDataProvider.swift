//
//  ImageDataProvider.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 06/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func getImage(url: String, completion: @escaping ((UIImage) -> Void))
}

public class ImageDataProvider: ImageProvider {
    private let httpClient = HTTPClient.shared

    func getImage(url: String, completion: @escaping ((UIImage) -> Void)) {
        guard let imageURL = URL(string: url) else {
            return
        }

        let request = URLRequest(url: imageURL)
        httpClient.getData(request: request) { data in
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(UIImage(named: "PlaceholderImage")!)
            }
        }
    }
}
