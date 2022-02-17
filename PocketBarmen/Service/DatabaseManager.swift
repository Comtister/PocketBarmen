//
//  DatabaseManager.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 17.02.2022.
//

import Foundation
import RealmSwift

class DatabaseManager{
    
    static let shared : DatabaseManager = DatabaseManager()
    private let realm : Realm
    
    private init(){
        self.realm = try! Realm()
        print(realm.configuration.fileURL)
    }
    
    func getFavoriteCocktails() -> [CocktailSummary]{
        let cocktails = realm.objects(CocktailSummary.self)
        let index = IndexSet(integersIn: cocktails.startIndex...cocktails.endIndex)
        let result = cocktails.objects(at: index)
        return result
    }
    
    func getCocktail(id : String) -> CocktailSummary?{
        let cocktail = realm.object(ofType: CocktailSummary.self, forPrimaryKey: id)
        return cocktail
    }
    
    func saveCocktail(cocktail : CocktailSummary , complete : @escaping () -> Void){
        try! realm.write({
            realm.add(cocktail)
            complete()
        })
    }
    
}
