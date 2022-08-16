//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import SnapKit

final class VideoViewController: UIViewController {
    fileprivate let sectionTitles = ["영화", "TV", "Popular", "Comming Soon", "지금 뜨는 컨텐츠"]
    
    fileprivate enum Section: Int {
        case Movie = 0
        case TV
        case Popular
        case CommingSoon
        case TopRates
    }

    private let tableView: UITableView = {
        $0.register(CollectionViewTableViewCEll.self, forCellReuseIdentifier: CollectionViewTableViewCEll.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    private var videoHeaderView: VideoHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.configureNavigationBar()
        
        self.videoHeaderView = VideoHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        self.tableView.tableHeaderView = self.videoHeaderView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureHeaderView()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.tableView.frame = self.view.bounds
//    }
}

extension VideoViewController {
    private func setupLayout() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
//        let image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
       
        let personButton = UIButton(type: .system)
        personButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        let person = UIBarButtonItem(customView: personButton)
        
        let playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.rectangle"), for: .normal)
        let play = UIBarButtonItem(customView: playButton)
        
        self.navigationItem.rightBarButtonItems = [
            person,
            play,
        ]
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        SimpleAPI.shared.movies { [weak self] result in
            switch result {
            case .success(let movies):
                guard let movieModel = movies.randomElement() else { return }

                let movieViewModel = MovieViewModel(movieModel: movieModel)
                
                DispatchQueue.main.async {
                    self?.videoHeaderView?.configure(with: movieViewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCEll.identifier, for: indexPath) as! CollectionViewTableViewCEll
        
        switch indexPath.section {
        case Section.Movie.rawValue:
            SimpleAPI.shared.movies {
                switch $0 {
                case .success(let movies):
                    let movieViewModels = movies.map {
                        MovieViewModel(movieModel: $0)
                    }
                    
                    cell.configure(with: movieViewModels)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TV.rawValue:
            SimpleAPI.shared.tv {
                switch $0 {
                case .success(let movies):
                    let tvViewModels = movies.map {
                        MovieViewModel(movieModel: $0)
                    }
                    cell.configure(with: tvViewModels)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            break
        case Section.CommingSoon.rawValue:
            break
        case Section.TopRates.rawValue:
            break
        default:
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 200, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized
        header.textLabel?.textColor = .red
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
}
