//
//  TitleCellDataSource.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/19.
//

import UIKit
import RxDataSources

struct Section {
    var header: String
    var items: [Item]
}

extension Section: SectionModelType {
    typealias Item = MovieModel
    
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}

struct TitleCellDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    static func dataSource() -> DataSource<Section> {
        .init { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            
            cell.viewModel = .init(model: item)
            
            return cell
        }
    }
}
