//
//  Artist.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 11/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct Artist: Decodable, Hashable {
    let id: Int
    let name: String
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture = "picture_medium"
    }
}

struct APIArtist: Decodable{
    let data: [Artist]
}
