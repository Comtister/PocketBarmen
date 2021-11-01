//
//  CatalogCoordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.10.2021.
//

import Foundation
import UIKit

class CatalogCoordinator : Coordinator{
    
    var subCoordinators: [Coordinator] = []
    var navController : UINavigationController
    var storyboard : UIStoryboard
    
    init(navController : UINavigationController) {
        self.navController = navController
        navController.navigationBar.prefersLargeTitles = true
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func start() {
        let VC = storyboard.instantiateViewController(identifier: "CatalogVC", creator: { coder in
            let viewModel = DiscoverViewModel()
            return DiscoverViewController(coder: coder, viewModel: viewModel, coordinator: self)
        })
        
        navController.pushViewController(VC, animated: true)
    }
    
}
