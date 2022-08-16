//
//  SearchedMovieViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/16.
//

import UIKit

final class SearchedMovieViewController: UIViewController {
    var movies = [MovieModel]()
    
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
        let movieViewModel = MovieViewModel(movieModel: movies[indexPath.row])

        cell.configure(with: movieViewModel)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        let movieViewModel = MovieViewModel(movieModel: movie)
        print(movieViewModel.titleName)
    }
}
