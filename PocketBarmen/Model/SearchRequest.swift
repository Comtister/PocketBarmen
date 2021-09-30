//
//  SearchRequest.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 30.09.2021.
//

import Foundation

class SearchRequest: NetRequestModel {
    
    var searchText : String
    
    override var baseUrl: String{
        return "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    override var path: String{
        return "search.php"
    }
    
    override var body: [String : String]?{
        return ["s" : searchText]
    }
    
    init(searchText : String){
        self.searchText = searchText
    }
    
}
