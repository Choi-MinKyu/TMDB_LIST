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
        
//        {
        videoViewControllerNavi.tabBarItem.image = UIImage(systemName: "video")
        videoViewControllerNavi.title = "Video"
//        }(videoViewControllerNavi)

//        {
        commingSoonViewControllerNavi.tabBarItem.image = UIImage(systemName: "play.circle")
        commingSoonViewControllerNavi.title = "Coming Soon"
//        }(commingSoonViewControllerNavi)
        
        searchViewControllerNavi.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchViewControllerNavi.title = "Search"

        downloadViewControllerNavi.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        downloadViewControllerNavi.title = "Download"
        
        self.tabBar.tintColor = .label
        
        self.setViewControllers([videoViewControllerNavi,
                                 searchViewControllerNavi,
                                 commingSoonViewControllerNavi,
                                 downloadViewControllerNavi], animated: true)
    }
}
