//
//  APIError.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 07/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

enum APIError: Error {
    case network(_ statusCode: Int)
    case unknown(_ error: Error)
    case decoding
}
