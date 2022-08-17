//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var movies = [MovieViewModel]()
    
    private let tableView: UITableView = {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        return $0
    }(UITableView())
    
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = "영화 또는 TV 타이틀을 입력하세요..."
        $0.searchBar.searchBarStyle = .minimal
        
        return $0
    }(UISearchController(searchResultsController: SearchedMovieViewController()))
    
    enum Constants {
        static let cellHeight: CGFloat = 160
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        self.fetchMovies()
    }
    
}

extension SearchViewController {
    private func setupLayout() {
        _ = {
            $1?.addSubview($0)
            $0.delegate = $2
            $0.dataSource = $2
        }(self.tableView, self.view, self)
        
        _ = {
            $0.searchResultsUpdater = self
        }(self.searchController)
        
        _ = {
            $0.title = $1
            $0.navigationItem.largeTitleDisplayMode = .always
            $0.navigationItem.searchController = self.searchController
            $2?.navigationBar.prefersLargeTitles = true
            $2?.navigationBar.tintColor = .white
        }(self, "Search", self.navigationController)
    }
    
    private func fetchMovies() {
        SimpleAPI.shared.searchDefault { [weak self] in
            guard let self = self else { return }
            
            switch $0 {
            case .success(let movies):
                self.movies = movies.map {
                    MovieViewModel(movieModel: $0)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        let movieViewModel = movies[safe: indexPath.row]
        cell.configure(with: movieViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieModel = self.movies[safe: indexPath.row]
        
        let titleName = (movieModel?.titleName.isEmpty ?? true) ? movieModel?.title ?? "" : movieModel?.titleName ?? ""
        
        SimpleAPI.shared.youtube(with: titleName) { [weak self] in
            guard let self = self else { return }
            
            switch $0 {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    let detailViewController = VideoDetailViewController()
                    detailViewController.configure(with: YoutubeSearchViewModel(title: titleName, youtubeViewElement: videoElement, overView: movieModel?.overView ?? ""))
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let seardedQuery = searchBar.text,
              !seardedQuery.trimmingCharacters(in: .whitespaces).isEmpty,
              seardedQuery.trimmingCharacters(in: .whitespaces).count >= 2,
              let searchedMovieViewController = searchController.searchResultsController as? SearchedMovieViewController else {
            return
        }
        
        searchedMovieViewController.delegate = self
        
        SimpleAPI.shared.search(with: seardedQuery) {
            switch $0 {
            case .success(let movies):
                searchedMovieViewController.movies = movies.map {
                    MovieViewModel(movieModel: $0)
                }
                
                DispatchQueue.main.async {
                    searchedMovieViewController.searchedMovieCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: SearchedMovieViewControllerDelegate {
    func searchedMovieViewControllerDidTapItem(_ viewModel: YoutubeSearchViewModel) {
        
        DispatchQueue.main.async {
            let detailViewController = VideoDetailViewController()
            detailViewController.configure(with: viewModel)
            self.navigationController?.pushViewController(detailViewController, animated: true)            
        }
    }
}
