//
//  TrackDetail.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 19/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct TrackDetail: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let track_position: Int
    let disk_number: Int
    let contributors: [Artist]
}

struct TrackDetailData: Decodable {
    let data: [TrackDetail]
}
