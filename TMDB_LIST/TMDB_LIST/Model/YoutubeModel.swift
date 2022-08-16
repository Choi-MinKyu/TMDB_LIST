//
//  YoutubeViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/16.
//

import Foundation

struct YoutubeSearchModel: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
