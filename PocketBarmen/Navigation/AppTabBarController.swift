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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(named: "MainBrass")
        catalogCoordinator.start()
        searchCoordinator.start()
        viewControllers = [catalogCoordinator.navController , searchCoordinator.navController]
        let catalogItem = UITabBarItem(title: "Catalog", image: UIImage(named: "CatalogImage"), tag: 0)
        let searchItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        viewControllers![0].tabBarItem = catalogItem
        viewControllers![1].tabBarItem = searchItem
    }
    

}
