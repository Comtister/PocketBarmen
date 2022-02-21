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
        return realm.object(ofType: CocktailSummary.self, forPrimaryKey: id)
    }
    
    func saveCocktail(cocktail : CocktailSummary , complete : @escaping (DatabaseError?) -> Void){
        
        if let _ = realm.object(ofType: CocktailSummary.self, forPrimaryKey: cocktail.id){
            complete(DatabaseError.DataExists)
        }else{
            
            do{
                try realm.write({
                    print(Thread.current.name)
                    let newCocktail = cocktail.copy() as! CocktailSummary
                    realm.add(newCocktail)
                    complete(nil)
                })
            }catch{
                //Handle Error
                complete(DatabaseError.WriteError)
            }
            
        }
        
    }
    
    func deleteCocktail(cocktail : CocktailSummary){
        do{
            try realm.write({
                if let object = realm.object(ofType: CocktailSummary.self, forPrimaryKey: cocktail.id){
                    realm.delete(object)
                }
            })
        }catch{
            print(error)
        }
       
    }
    
}
