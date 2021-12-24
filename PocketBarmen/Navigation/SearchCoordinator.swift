//
//  SearchCoordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.10.2021.
//

import Foundation
import UIKit

class SearchCoordinator : NSObject , Coordinator , UINavigationControllerDelegate{
    
    var subCoordinators: [Coordinator] = []
    var navController : UINavigationController
    var storyboard : UIStoryboard
    
    init(navController : UINavigationController) {
        self.navController = navController
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func start() {
        navController.delegate = self
        let VC = storyboard.instantiateViewController(identifier: "SearchVC", creator: { coder in
            let viewModel = SearchViewModel()
            return SearchViewController(coder: coder, viewModel: viewModel, coordinator: self)
        })
        navController.pushViewController(VC, animated: true)
    }
    
    func changePage(drinkId : String){
        let child = CocktailDetailCoordinator(navController: navController , drinkId: drinkId)
        child.parentCoordinator = self
        subCoordinators.append(child)
        child.start()
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
