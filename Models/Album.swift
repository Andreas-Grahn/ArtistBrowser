//
//  Album.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 11/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let id: Int
    let title: String
    let cover: String
    let tracks: Int?
    var artist: Artist?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover = "cover_big"
        case tracks = "nb_tracks"
        case artist
    }
}

struct DataAlbum: Decodable {
    let data: [Album]
}
