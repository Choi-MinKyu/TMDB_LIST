//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class VideoViewController: UIViewController {
    fileprivate let sectionTitles = ["영화", "TV", "Popular", "Comming Soon", "지금 뜨는 컨텐츠"]
    let headerViewSubject = PublishSubject<[MovieModel]>()
    let disposeBag = DisposeBag()
    
    fileprivate enum Section: Int {
        case Movie = 0
        case TV
        case Popular
        case CommingSoon
        case TopRates
    }
    
    private enum Constants {
        static let cellHeight: CGFloat = 200
        static let headerCellHeight: CGFloat = 40
        static let headerViewHeight: CGFloat = 500
    }

    private let tableView: UITableView = {
        $0.register(CollectionViewTableViewCEll.self, forCellReuseIdentifier: CollectionViewTableViewCEll.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    private var videoHeaderView: VideoHeaderView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.rx.viewDidLoad
            .bind(onNext: self.setupLayout)
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidLoad.bind(onNext: self.configureNavigationBar)
            .disposed(by: self.disposeBag)
        
        self.headerViewSubject
            .compactMap { $0.randomElement() }
            .map { MovieViewModel(movieModel: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, viewModel in
                owner.videoHeaderView?.configure(with: viewModel)
            })
            .disposed(by: self.disposeBag)

        self.rx.viewWillAppear.bind(onNext: self.configureHeaderView)
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidLoad
            .subscribe(with: self, onNext: { owner, _ in
                owner.videoHeaderView = VideoHeaderView(frame: CGRect(x: 0, y: 0, width: owner.view.bounds.width, height: Constants.headerViewHeight))
                owner.tableView.tableHeaderView = self.videoHeaderView
            })
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tableView.frame = self.view.bounds
    }
}

extension VideoViewController: ViewModelBindableType {
    func bindInput(viewModel: MovieViewModel) {
        self.rx.viewDidLoad
            .map{ _ in .load }
            .bind(to: viewModel.input)
            .disposed(by: self.disposeBag)
    }
    
    func bindOutput(viewModel: MovieViewModel) {
        viewModel.output
            .models
            .drive(onNext: {
                print($0)
            })
            .disposed(by: self.disposeBag)
    }
}

extension VideoViewController {
    private func setupLayout() {
        self.view.backgroundColor = .systemBackground
        
        _ = {
            self.view.addSubview($0)
            $0.delegate = self
            $0.dataSource = self
        }(self.tableView)
    }
    
    private func configureNavigationBar() {
        let logoImage = UIImage(named: "LOGO")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
       
        let personButton = UIButton(type: .system)
        personButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        let person = UIBarButtonItem(customView: personButton)
        
        let playButton = UIButton(type: .system)
        playButton.setImage(UIImage(systemName: "play.rectangle"), for: .normal)
        let play = UIBarButtonItem(customView: playButton)
        
        self.navigationItem.rightBarButtonItems = [person, play]
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        SimpleAPI.shared.movies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.headerViewSubject.onNext(movies)
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
        
        cell.delegate = self
        
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
            SimpleAPI.shared.popular {
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
        case Section.CommingSoon.rawValue:
            SimpleAPI.shared.commingSoon {
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
        case Section.TopRates.rawValue:
            SimpleAPI.shared.topRates {
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
        default:
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerCellHeight
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = self.view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
        
    }
}

extension VideoViewController: CollectionViewTableViewCEllDelegate {
    func CollectionViewTableViewCEllDidTapCell(_ cell: CollectionViewTableViewCEll, viewModel: YoutubeSearchViewModel) {
        
        DispatchQueue.main.async {
            let detailViewController = VideoDetailViewController()
            detailViewController.configure(with: viewModel)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
