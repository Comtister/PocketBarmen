//
//  CategoryRequestModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 7.09.2021.
//

import Foundation

class CategoryRequestModel : NetRequestModel {
    
    override var baseUrl: String{
        return "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    override var path: String{
        return "list.php"
    }
    
    override var body: [String : String]?{
        return ["c" : "list"]
    }
    
}
