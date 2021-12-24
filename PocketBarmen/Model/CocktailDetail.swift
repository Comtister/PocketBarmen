//
//  CocktailDetail.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.11.2021.
//

import Foundation

class CocktailDetail : Codable{
    
    var id : String
    var name : String
    var category : String
    var instructions : String
    var imageUrl : URL
    var ingredients : [String] = []
    var measures : [String] = []
    
    enum CodingKeys : String , CodingKey{
       case id = "idDrink" , name = "strDrink" , category = "strCategory" , instructions = "strInstructions" , imageUrl = "strDrinkThumb"
    }
    
    enum IngredientsCodes : String , CaseIterable , CodingKey{
        case strIngredient1 , strIngredient2 , strIngredient3 , strIngredient4 , strIngredient5 , strIngredient6 , strIngredient7 , strIngredient8 ,
             strIngredient9 , strIngredient10 , strIngredient11 , strIngredient12 , strIngredient13 , strIngredient14 , strIngredient15
    }
    
    enum MeasuresCodes : String , CaseIterable , CodingKey{
        case strMeasure1 , strMeasure2 , strMeasure3 , strMeasure4 ,strMeasure5 ,strMeasure6 ,strMeasure7 ,strMeasure8 ,strMeasure9 ,strMeasure10 ,
             strMeasure11 ,strMeasure12 ,strMeasure13 ,strMeasure14 ,strMeasure15
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(String.self, forKey: .category)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        
        let ingredientContainer = try decoder.container(keyedBy: IngredientsCodes.self)
        
        for i in 0...14{
            let ingredient = try? ingredientContainer.decode(String.self, forKey: IngredientsCodes.allCases[i])
            if let ingredient = ingredient{
                self.ingredients.append(ingredient)
            }
        }
        
        let measureContainer = try decoder.container(keyedBy: MeasuresCodes.self)
        
        for i in 0...14{
            let measure = try? measureContainer.decode(String.self, forKey: MeasuresCodes.allCases[i])            
            if let measure = measure{
                self.measures.append(measure)
            }
        }
        
    }
    
}
