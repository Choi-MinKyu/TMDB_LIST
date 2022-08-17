//
//  TMDBTabBarViewController.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit

final class TMDBTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let videoViewControllerNavi = UINavigationController(rootViewController: VideoViewController())
        let commingSoonViewControllerNavi = UINavigationController(rootViewController: CommingSoonViewController())
        let searchViewControllerNavi = UINavigationController(rootViewController: SearchViewController())
        let downloadViewControllerNavi = UINavigationController(rootViewController: DownloadViewController())
        
        _ = {
            $0.tabBarItem.image = UIImage(systemName: "video")
            $0.title = "비디오"
        }(videoViewControllerNavi)

        _ = {
            $0.tabBarItem.image = UIImage(systemName: "play.circle")
            $0.title = "Coming Soon"
        }(commingSoonViewControllerNavi)
        
        _ = {
            $0.tabBarItem.image = UIImage(systemName: "magnifyingglass")
            $0.title = "검색"
        }(searchViewControllerNavi)

        _ = {
            $0.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
            $0.title = "다운로드"
        }(downloadViewControllerNavi)
        
        self.tabBar.tintColor = .label
        
        self.setViewControllers([videoViewControllerNavi,
                                 searchViewControllerNavi,
                                 commingSoonViewControllerNavi,
                                 downloadViewControllerNavi], animated: true)
    }
}
