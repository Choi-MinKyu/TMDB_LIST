//
//  ViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import Foundation

struct MovieViewModel {
    let movieModel: MovieModel
    
    var titleName: String {
        self.movieModel.original_title ?? ""
    }
    
    var thumbnailImageUrl: String {
        self.movieModel.poster_path ?? ""
    }
}
