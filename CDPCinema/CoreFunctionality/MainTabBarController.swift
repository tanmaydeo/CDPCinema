//
//  MainTabBarController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        //VC for Popular Movies
        let popularVC = UIStoryboard(name: "MoviesListViewController", bundle: nil).instantiateViewController(withIdentifier: "MoviesListVC")
        popularVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film.fill"), tag: 0)
        let popularNav = UINavigationController(rootViewController: popularVC)
        
        //VC for Search
        let exploreVC = UIStoryboard(name: "MoviesListViewController", bundle: nil).instantiateViewController(withIdentifier: "MoviesListVC")
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let exploreNav = UINavigationController(rootViewController: exploreVC)
        
        let favouritesVC = FavouritesViewController()
        favouritesVC.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart.fill"), tag: 2)
        let favouritesNav = UINavigationController(rootViewController: favouritesVC)
        
        // Set view controllers
        self.viewControllers = [popularNav, exploreNav, favouritesNav]
    }
}
