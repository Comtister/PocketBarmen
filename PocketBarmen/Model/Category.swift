//
//  Category.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 8.09.2021.
//

import Foundation

struct Category : Codable{
    
    var name : String
    
    enum CodingKeys : String, CodingKey{
        case name = "strCategory"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}
