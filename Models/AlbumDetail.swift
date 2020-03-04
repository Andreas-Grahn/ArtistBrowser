//
//  AlbumDetail.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 16/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct AlbumDetail: Decodable {

    var id: Int
    var title: String
    var cover: String
    var artist: Artist
    var tracks: DataTrack

        enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover = "cover_xl"
        case artist
        case tracks
    }

}
