//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

final class CommingSoonViewController: UIViewController {
    
    enum Constants {
        static let cellHeight: CGFloat = 150
    }
    
    private var movies = [MovieModel]()
    
    private let commingSoonTableView: UITableView = {
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        return $0
    }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.fetchCommingSoon()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.commingSoonTableView.frame = self.view.bounds
    }

}

extension CommingSoonViewController {
    private func setupLayout() {
        
        _ = {
            $0.view.backgroundColor = .systemBackground
            $0.title = "Comming Soon"
        }(self)
        
        _ = {
            $0?.navigationBar.prefersLargeTitles = true
            $0?.navigationItem.largeTitleDisplayMode = .always
        }(self.navigationController)
        
        _ = {
            self.view.addSubview($0)
            $0.delegate = self
            $0.dataSource = self
        }(self.commingSoonTableView)
    }
    
    private func setupConstraints() {
        
    }
    
    private func fetchCommingSoon() {
        SimpleAPI.shared.commingSoon { [weak self] in
            switch $0 {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.commingSoonTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CommingSoonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let movieViewModel = MovieViewModel(movieModel: movies[safe: indexPath.row])
        cell.configure(with: movieViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}
