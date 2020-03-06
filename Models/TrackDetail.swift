//
//  TrackDetail.swift
//  ArtistBrowser
//
//  Created by Andreas Grahn on 19/02/2020.
//  Copyright © 2020 Andreas Grahn. All rights reserved.
//

import Foundation

struct TrackDetail: Decodable {
    var id: Int
    var title: String
    var duration: Int
    var track_position: Int
    var disk_number: Int
    var contributors: [Artist]
}

struct TrackDetailData: Decodable {
    var data: [TrackDetail]
}
