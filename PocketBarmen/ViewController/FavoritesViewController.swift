//
//  FavoritesViewController.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 16.02.2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    private let viewModel : FavoritesViewModel
    
    required init?(coder: NSCoder , viewModel : FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
