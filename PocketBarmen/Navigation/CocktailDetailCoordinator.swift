//
//  CocktailDetailCoordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 9.11.2021.
//

import Foundation
import UIKit

class CocktailDetailCoordinator : Coordinator{
    
    var subCoordinators: [Coordinator] = []
    weak var parentCoordinator : SearchCoordinator?
    private var navController : UINavigationController
    var storyboard : UIStoryboard
    private let drinkId : String
    
    init(navController : UINavigationController , drinkId : String) {
        self.navController = navController
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.drinkId = drinkId
    }
    
    func start() {
        let VC = storyboard.instantiateViewController(identifier: "DetailVC") { (coder) in
            let viewModel = CocktailDetailViewModel(drinkID: self.drinkId)
            let vc = CocktailDetailViewController(coder: coder, coordinator: self, viewModel: viewModel)
            return vc
        }
        navController.pushViewController(VC, animated: true)
    }
    
}
