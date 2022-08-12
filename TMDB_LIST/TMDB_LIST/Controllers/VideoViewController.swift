//
//  VideoViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
}

extension VideoViewController {
    private func setupLayout() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func configureNavigationBar() {
        let image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        self.navigationController?.navigationBar.tintColor = .white
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
            break
        case Section.TV.rawValue:
            break
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
