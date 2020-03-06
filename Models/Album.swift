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
    var artist: Artist?
    let tracksIds: TrackIdData
    var tracks: [TrackDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover = "cover_big"
        case artist
        case tracksIds = "tracks"
    }
}

struct TrackIdData: Decodable {
    let data: [TrackId]
}

struct TrackId: Decodable {
    let id: Int
}


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
