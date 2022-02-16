//
//  FavoritesCoordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 16.02.2022.
//

import Foundation
import UIKit

class FavoritesCoordinator : NSObject , Coordinator , UINavigationControllerDelegate{
    
    var subCoordinators: [Coordinator] = []
    let navController : UINavigationController
    let storyboard : UIStoryboard
    
    init(navController : UINavigationController){
        self.navController = navController
        self.storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
    }
    
    func start() {
        
        let VC = storyboard.instantiateViewController(identifier: "FavoritesVC") { coder in
            let vm = FavoritesViewModel()
            let vc = FavoritesViewController(coder: coder, viewModel: vm)
            return vc
        }
        navController.pushViewController(VC, animated: true)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        
        if let detailViewController = fromViewController as? CocktailDetailViewController{
            removeSubCoordinator(coordinator: detailViewController.coordinator!)
        }
    }
    
}
