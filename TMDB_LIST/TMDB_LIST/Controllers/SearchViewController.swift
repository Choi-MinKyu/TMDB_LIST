//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

final class SearchViewController: UIViewController {

    private var movies = [MovieModel]()
    
    private let tableView: UITableView = {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)

        return $0
    }(UITableView())

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
            $0.title = $1
            $2?.navigationItem.largeTitleDisplayMode = .always
            $2?.navigationBar.prefersLargeTitles = true
            $2?.navigationBar.tintColor = .white
        }(self, "Search", self.navigationController)
    }
    
    private func fetchMovies() {
        SimpleAPI.shared.searchDefault { [weak self] in
            switch $0 {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
        
        let movieModel = movies[indexPath.row]
        let movieViewModel = MovieViewModel(movieModel: movieModel)
        
        cell.configure(with: movieViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
