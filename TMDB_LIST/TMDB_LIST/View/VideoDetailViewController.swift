//
//  VideoDetailViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/16.
//

import UIKit
import WebKit
import SnapKit

final class VideoDetailViewController: UIViewController {
    private let titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        return $0
    }(UILabel())
    
    private let overViewlabel: UILabel = {
        $0.font = .systemFont(ofSize: 18)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let downloadButton: UIButton = {
        $0.setTitle("다운로드", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        return $0
    }(UIButton())
    
    private let webView: WKWebView = {
        
        return $0
    }(WKWebView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
}

extension VideoDetailViewController {
    func configure(with viewModel: YoutubeSearchViewModel) {
        self.titleLabel.text = viewModel.title
        self.overViewlabel.text = viewModel.overView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(viewModel.youtubeViewElement.id.videoId)") else { return }
        
        self.webView.load(URLRequest(url: url))
    }
}

extension VideoDetailViewController {
    private func setupLayout() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.webView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.overViewlabel)
        self.view.addSubview(self.downloadButton)
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.webView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.webView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        self.overViewlabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        self.downloadButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.overViewlabel.snp.bottom).offset(25)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
    }
}
