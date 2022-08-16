//
//  VideoHeaderView.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/13.
//

import UIKit
import SnapKit

final class VideoHeaderView: UIView {
    private let downloadButton: UIButton = {
        $0.setTitle("다운로드", for: .normal)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        
        return $0
    }(UIButton())

    private let playButton: UIButton = {
        $0.setTitle("재생", for: .normal)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        
        return $0
    }(UIButton())
    
    private let thumbnailImageView: UIImageView = {
        $0.image = UIImage(named: "videoImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with movieViewModel: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movieViewModel.thumbnailImageUrl)") else { return }
        
        self.thumbnailImageView.kf.setImage(with: url)
    }
}

extension VideoHeaderView {
    private func setupUI() {
        self.addSubview(self.thumbnailImageView)
        self.addSubview(self.playButton)
        self.addSubview(self.downloadButton)
    }
    
    private func setupConstraints() {
        self.thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.playButton.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.centerX).offset(-10)
            $0.width.equalTo(120)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        self.downloadButton.snp.makeConstraints {
            $0.leading.equalTo(self.snp.centerX).offset(10)
            $0.width.equalTo(120)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
