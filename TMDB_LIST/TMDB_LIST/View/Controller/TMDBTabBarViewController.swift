//
//  TMDBTabBarViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import RxSwift
import RxCocoa

protocol Tea {
    associatedtype Identifier
    var id: Identifier { get }
}

struct GreenTea: Tea {
    let id: String
    init(id: String) {
        self.id = id
    }
}

func favoriteTea() -> some Tea {
    return GreenTea(id: "someId")
}


protocol TEST {
    func toView() -> UIViewController
}

extension UIViewController: TEST {
    func toView() -> UIViewController {
        self
    }
}

final class TMDBTabBarViewController: UITabBarController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoViewControllerObservable = Observable.just(VideoViewController())
            .map {  v -> TEST in
                v.tabBarItem.image = UIImage(systemName: "video")
                v.title = "비디오"
                
                return v
            }

        
        let commingSoonViewControllerObservable = Observable.just(CommingSoonViewController())
            .map { v -> TEST in
                v.tabBarItem.image = UIImage(systemName: "play.circle")
                v.title = "Coming Soon"
                
                return v
            }

        
        let searchViewControllerObservable = Observable.just(SearchViewController())
            .map { v -> TEST in
                v.tabBarItem.image = UIImage(systemName: "magnifyingglass")
                v.title = "검색"
                
                return v
            }

        
        let downloadViewControllerObservable = Observable.just(DownloadViewController())
            .map { v -> TEST in
                v.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
                v.title = "다운로드"
                
                return v
            }

        
        self.tabBar.tintColor = .label

        Observable<TEST>.concat([videoViewControllerObservable, commingSoonViewControllerObservable, searchViewControllerObservable, downloadViewControllerObservable])
            .map { $0.toView() }
            .toArray()
            .asObservable()
            .subscribe(with: self, onNext: {
                $0.setViewControllers($1, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
