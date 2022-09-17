//
//  VideoDataSource.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/09/17.
//

import UIKit
import RxDataSources

enum VideoSectionModel {
    case thumbnail(title: String, items: [VideoSectionItem])
}

enum VideoSectionItem {
    case ImageSectionItem(CollectionTableViewCEllViewModel)
}

extension VideoSectionModel: SectionModelType {
    typealias Item = VideoSectionItem
    
    init(original: VideoSectionModel, items: [VideoSectionItem]) {
        switch original {
        case let .thumbnail(title: title, items: _):
            self = .thumbnail(title: title, items: items)
        }
        
    }
    
    var items: [VideoSectionItem] {
        switch self {
        case .thumbnail(title: _, items: let items):
            return items.map { $0 }
        }
    }
}

extension VideoSectionModel {
    var title: String {
        switch self {
        case .thumbnail(title: let title, items: _):
            return title
        }
    }
}

struct VideoViewDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<VideoSectionModel> {
        .init { dataSource, tableView, index, item -> UITableViewCell in
            switch dataSource[index] {
            case .ImageSectionItem(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCEll.identifier, for: index) as! CollectionViewTableViewCEll
                cell.viewModel = viewModel
                return cell
            }
        } titleForHeaderInSection: { datasource, index in
            let section = datasource[index]
            return section.title
        }
    }
}
