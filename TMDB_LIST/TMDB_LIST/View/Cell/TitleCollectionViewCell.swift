//
//  TitleCollectionViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import Kingfisher

final class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(thumbnailImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumbnailImageView.frame = self.contentView.bounds
    }
}

extension TitleCollectionViewCell {
    func configure(with viewModel: MovieViewModel?) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel?.thumbnailImageUrl ?? "")") else { return }
        
        self.thumbnailImageView.kf.setImage(with: url)
    }
}
