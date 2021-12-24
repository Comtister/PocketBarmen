//
//  CocktailDetailRequest.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.11.2021.
//

import Foundation

class CocktailDetailRequest : NetRequestModel{
    
    var id : String
    
    override var baseUrl: String{
        return "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    override var path: String{
        return "lookup.php"
    }
    
    override var body: [String : String]?{
        return ["i" : id]
    }
    
    init(id : String) {
        self.id = id
    }
    
}
