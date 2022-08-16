//
//  CollectionViewTableViewCellCollectionViewCell.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

final class CollectionViewTableViewCEll: UITableViewCell {
    static let identifier = "CollectionViewTableViewCellCollectionViewCell"
    
    private var viewModels = [MovieViewModel]()
    
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

extension CollectionViewTableViewCEll: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: self.viewModels[indexPath.row])

        return cell
    }
}
