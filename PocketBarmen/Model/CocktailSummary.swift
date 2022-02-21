//
//  CocktailSummary.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation
import UIKit
import RealmSwift

class CocktailSummary : Object , Codable , NSCopying {
   
    
    
    
    @Persisted(primaryKey: true) var id : String
    @Persisted var drinkName : String
    @Persisted var imageUrl : String
    @Persisted var type : String
    var imageDownloadUrl : URL{
        get{
            let url = URL(string: imageUrl)!
            let downloadUrl = url.appendingPathComponent("/preview")
            return downloadUrl
        }
    }
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
        /*
    init(cocktailDetail : CocktailDetail){
        super.init()
        self.id = cocktailDetail.id
        self.drinkName = cocktailDetail.name
        self.imageUrl = cocktailDetail.imageUrl
        self.type = cocktailDetail.category
        
    }*/
    
    convenience init(cocktailDetail : CocktailDetail) {
        self.init()
        self.id = cocktailDetail.id
        self.drinkName = cocktailDetail.name
        self.imageUrl = cocktailDetail.imageUrl
        self.type = cocktailDetail.category
    }
    
    
    convenience init(id : String , drinkName : String , imageUrl : String , type : String) {
        self.init()
        self.id = id
        self.drinkName = drinkName
        self.imageUrl = imageUrl
        self.type = type
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return CocktailSummary(id: id, drinkName: drinkName, imageUrl: imageUrl, type: type)
    }
    
}
