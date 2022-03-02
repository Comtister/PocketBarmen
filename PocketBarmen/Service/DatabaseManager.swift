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
    private var realm : Realm
    
    private let realmQueue = DispatchQueue.init(label: "RealmQueue" , qos: .userInitiated)
    
    private init(){
        self.realm = try! Realm()
        print(realm.configuration.fileURL)
    }
    
    func getFavoriteCocktails(completion : @escaping (Results<CocktailSummary>?) -> Void){
        
        realmQueue.async {
            let realm = try! Realm()
            
            @ThreadSafe var cocktails = realm.objects(CocktailSummary.self)
           
            //let index = IndexSet(integersIn: cocktails.startIndex...cocktails.endIndex - 1)
            //@ThreadSafe var result = cocktails.objects(at: index)
            
            DispatchQueue.main.async{ completion(cocktails) }
            
        }
        
    }
    
    func getCocktail(id : String) -> CocktailSummary?{
        return realm.object(ofType: CocktailSummary.self, forPrimaryKey: id)
    }
    
    func saveCocktail(cocktail : CocktailSummary , complete : @escaping (DatabaseError?) -> Void){
        
        realmQueue.async {
            
            let realm = try! Realm()
            
            if let _ = realm.object(ofType: CocktailSummary.self, forPrimaryKey: cocktail.id){
                DispatchQueue.main.async{ complete(DatabaseError.DataExists) }
                return
            }
            
            do{
                try realm.write({
                    guard let cocktailCopy = cocktail.copy() as? CocktailSummary else{
                        DispatchQueue.main.async{ complete(DatabaseError.WriteError) }
                        return
                    }
                    realm.add(cocktailCopy)
                    DispatchQueue.main.async{ complete(nil) }
                })
            }catch{
                DispatchQueue.main.async {  complete(DatabaseError.WriteError) }
            }
            
        }
        
    }
    
    func deleteCocktail(cocktail : CocktailSummary , completion : @escaping (DatabaseError?) -> Void){
        
        realmQueue.async {
            let realm = try! Realm()
            do{
                try realm.write({
                    if let object = realm.object(ofType: CocktailSummary.self, forPrimaryKey: cocktail.id){
                        realm.delete(object)
                        DispatchQueue.main.async{ completion(nil) }
                    }
                })
            }catch{
                completion(DatabaseError.DeleteError)
            }
        }
        
    }
    
}
