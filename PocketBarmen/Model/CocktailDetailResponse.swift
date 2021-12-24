//
//  CocktailDetailResponse.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.11.2021.
//

import Foundation

struct CocktailDetailResponse : Codable {
    
    var drinks : [CocktailDetail]
    
    init() {
        self.drinks = [CocktailDetail]()
    }
    
}
