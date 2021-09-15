//
//  CocktailsRequetsModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation

class CocktailsRequestModel : NetRequestModel{
    
    var searchedCharacter : Character
    
    override var baseUrl: String{
        return "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    override var path: String{
        return "search.php"
    }
    
    override var body: [String : String]?{
        return ["f" : String(searchedCharacter)]
    }
    
    init(character : Character) {
        self.searchedCharacter = character
    }
    
}
