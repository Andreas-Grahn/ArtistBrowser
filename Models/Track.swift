//
//  Track.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 16/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct Track: Decodable {
    var id: Int
    var title: String
    var duration: Int
}

struct DataTrack: Decodable {
    var data: [Track]
}
