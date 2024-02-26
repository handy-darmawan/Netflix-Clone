//
//  MainTabBarViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadVC = UINavigationController(rootViewController: DownloadViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeVC.title = "Home"
        upcomingVC.title = "Coming Soon"
        searchVC.title = "Top Search"
        downloadVC.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, upcomingVC, searchVC, downloadVC], animated: true)
    }
}

