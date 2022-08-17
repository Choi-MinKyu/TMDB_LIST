//
//  Array+.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/17.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.indices ~= index else { return nil }
        
        return self[index]
    }
}
