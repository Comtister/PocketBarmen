//
//  CocktailSummary.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation

struct CocktailSummary : Codable {
    
    var id : String
    var drinkName : String
    var type : String
    var imageUrl : String
    
    enum CodingKeys : String , CodingKey{
        case id = "idDrink"
        case drinkName = "strDrink"
        case type = "strAlcoholic"
        case imageUrl = "strDrinkThumb"
    }
    
}
