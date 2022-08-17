//
//  SearchedMovieViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/16.
//

import UIKit

protocol SearchedMovieViewControllerDelegate: AnyObject {
    func searchedMovieViewControllerDidTapItem(_ viewModel: YoutubeSearchViewModel)
}

final class SearchedMovieViewController: UIViewController {
    var movies = [MovieViewModel]()
    
    weak var delegate: SearchedMovieViewControllerDelegate?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        $0.minimumInteritemSpacing = 0
        
        return $0
    }(UICollectionViewFlowLayout())
    
    lazy var searchedMovieCollectionView: UICollectionView = {
        $0.delegate = self
        $0.dataSource = self

        $0.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.searchedMovieCollectionView.frame = self.view.bounds
    }

}

extension SearchedMovieViewController {
    private func setupLayout() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.searchedMovieCollectionView)
    }
    
}

extension SearchedMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        
        cell.configure(with: self.movies[safe: indexPath.item])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movieViewModel = self.movies[indexPath.item]
        let titleName = movieViewModel.titleName.isEmpty ? movieViewModel.title : movieViewModel.titleName
        
        SimpleAPI.shared.youtube(with: titleName) { [weak self] in
            switch $0 {
            case .success(let videoElement):
                self?.delegate?.searchedMovieViewControllerDidTapItem(YoutubeSearchViewModel(title: movieViewModel.titleName, youtubeViewElement: videoElement, overView: movieViewModel.overView))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
