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
        catalogCoordinator.start()
        searchCoordinator.start()
        viewControllers = [catalogCoordinator.navController , searchCoordinator.navController]
       
    }
    

}
