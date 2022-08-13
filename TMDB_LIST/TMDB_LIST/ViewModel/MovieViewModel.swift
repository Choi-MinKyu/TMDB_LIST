//
//  ViewModel.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import Foundation

struct MovieViewModel {
    let movieModel: MovieModel
    
    func titleName() -> String {
        self.movieModel.original_title ?? ""
    }
    
    func thumnailImageURL() -> String {
        self.movieModel.poster_path ?? ""
    }
}
