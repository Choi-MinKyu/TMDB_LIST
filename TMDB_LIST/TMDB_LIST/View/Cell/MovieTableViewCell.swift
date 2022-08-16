//
//  MovieTableViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/16.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let thumbnailImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView())

    private let titleLable: UILabel = {
        
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieTableViewCell {
    func configure(with viewModel: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.thumbnailImageUrl)") else { return }
        
        self.thumbnailImageView.kf.setImage(with: .network(url))
        self.titleLable.text = viewModel.titleName
    }
}

extension MovieTableViewCell {
    private func setupLayout() {
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.titleLable)
    
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(100)
        }
        
        self.titleLable.snp.makeConstraints {
            $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
