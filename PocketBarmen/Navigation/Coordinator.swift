//
//  Coordinator.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 26.10.2021.
//

import Foundation

protocol Coordinator : AnyObject {
    
    var subCoordinators : [Coordinator] {get set}
    
    func start()
    
}

extension Coordinator{
    
    func appendSubCoordinator(coordinator : Coordinator){
        subCoordinators.append(coordinator)
    }
    
    func removeSubCoordinator(coordinator : Coordinator){
        subCoordinators = subCoordinators.filter({ $0 !== coordinator })
    }
    
}
