//
//  SearchResponse.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation

struct SearchResponse : Codable {
    
    var drinks : [CocktailSummary]
    
}
