//
//  AlbumThinned.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 08/03/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct AlbumThinned: Decodable {
    let id: Int
    let title: String
    let cover: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover = "cover_medium"
    }
}

struct AlbumThinnedData: Decodable {
    let data: [AlbumThinned]
}
