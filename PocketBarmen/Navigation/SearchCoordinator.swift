//
//  SearchCoordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.10.2021.
//

import Foundation
import UIKit

class SearchCoordinator : Coordinator{
    
    var subCoordinators: [Coordinator] = []
    var navController : UINavigationController
    var storyboard : UIStoryboard
    
    init(navController : UINavigationController) {
        self.navController = navController
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func start() {
        let VC = storyboard.instantiateViewController(identifier: "SearchVC", creator: { coder in
            let viewModel = SearchViewModel()
            return SearchViewController(coder: coder, viewModel: viewModel, coordinator: self)
        })
        navController.pushViewController(VC, animated: true)
    }
    
}
