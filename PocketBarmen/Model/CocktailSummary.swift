//
//  CocktailSummary.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation
import UIKit

struct CocktailSummary : Codable {
    
    var id : String
    var drinkName : String
    var type : String
    var imageUrl : URL
    var imageDownloadingState : Bool = false
    var image : UIImage? = nil
    var imageData : Data?{
        set{
            image = UIImage(data: newValue!)
        }
        get{
            return image?.pngData()
        }
    }
    
    enum CodingKeys : String , CodingKey{
        case id = "idDrink"
        case drinkName = "strDrink"
        case type = "strAlcoholic"
        case imageUrl = "strDrinkThumb"
    }
        
}
