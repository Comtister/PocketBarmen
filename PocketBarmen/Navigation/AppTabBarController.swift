//
//  AppTabBarController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.10.2021.
//

import UIKit

class AppTabBarController: UITabBarController {

    let catalogCoordinator = CatalogCoordinator(navController: UINavigationController())
    let searchCoordinator = SearchCoordinator(navController: UINavigationController())
    let favoritesCoordinator = FavoritesCoordinator(navController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(named: "MainBrass")
        catalogCoordinator.start()
        searchCoordinator.start()
        favoritesCoordinator.start()
        viewControllers = [catalogCoordinator.navController , searchCoordinator.navController , favoritesCoordinator.navController]
        let catalogItem = UITabBarItem(title: "Catalog", image: UIImage(named: "CatalogImage"), tag: 0)
        let searchItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let favoritesItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favourite"), tag: 2)
        viewControllers![0].tabBarItem = catalogItem
        viewControllers![1].tabBarItem = searchItem
        viewControllers![2].tabBarItem = favoritesItem
    }
    
}
