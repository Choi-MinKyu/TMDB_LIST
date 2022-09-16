//
//  CollectionViewTableViewCellCollectionViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import RxSwift

protocol CollectionViewTableViewCEllDelegate: AnyObject {
    func CollectionViewTableViewCEllDidTapCell(_ cell: CollectionViewTableViewCEll, viewModel: YoutubeSearchViewModel)
}

final class CollectionViewTableViewCEll: UITableViewCell {
    static let identifier = "CollectionViewTableViewCellCollectionViewCell"
    
    let disposeBag: DisposeBag = .init()
    
    private var viewModels = [MovieViewModel]()
    
    weak var delegate: CollectionViewTableViewCEllDelegate?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 140, height: 200)
        return $0
    }(UICollectionViewFlowLayout())
    
    private lazy var collectionView: UICollectionView = {
        $0.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.contentView.bounds
    }
    
    func configure(with viewModels: [MovieViewModel]) {
        self.viewModels = viewModels
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCEll: ViewModelBindableType {
    func bindInput(viewModel: MovieViewModel) {
        
    }
    
    func bindOutput(viewModel: MovieViewModel) {
        
    }
}

extension CollectionViewTableViewCEll: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: self.viewModels[safe: indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movieModel = self.viewModels[indexPath.item]
        
        let titleName = movieModel.titleName.isEmpty ? movieModel.title : movieModel.titleName
        
        SimpleAPI.shared.youtube(with: titleName) { [weak self] in
            guard let self = self else { return }
            
            switch $0 {
            case .success(let videoElement):
                guard !movieModel.overView.isEmpty else { return }
                let youtubeViewModel = YoutubeSearchViewModel(title: titleName, youtubeViewElement: videoElement, overView: movieModel.overView)
                self.delegate?.CollectionViewTableViewCEllDidTapCell(self, viewModel: youtubeViewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadActionButton = UIAction(title: "다운로드", state: .off) { _ in
                print("Touch 3DButton")
            }
            
            return UIMenu(title: "", options: .displayInline, children: [downloadActionButton])
        }
        
        return config
    }
}
