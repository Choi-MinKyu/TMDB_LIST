//
//  MovieModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import Foundation

struct Movies: Codable {
    let results: [MovieModel]
}

struct MovieModel: Codable {
    let id: Int
    let media_type: String?
    let title: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
