//
//  CocktailDetailViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 7.12.2021.
//

import Foundation
import RxSwift

class CocktailDetailViewModel{
    
    enum CocktailState{
        case Saved , Deleted
    }
    
    private let drinkID : String
    private var cocktailSummary : CocktailSummary?
    private let databaseManager = DatabaseManager.shared
    
    init(drinkID : String){
        self.drinkID = drinkID
    }
    
    func getDrinkDetail() -> Single<CocktailDetail>{
        
        return Single.create { [weak self] single in
            let disposable = Disposables.create()
            guard let drinkID = self?.drinkID else {single(.failure(NetworkServiceError.DataNotValid)) ; return disposable}
            
            let request = CocktailDetailRequest(id: drinkID)
            NetworkServiceManager.shared.sendRequest(request: request) { (result : Result<CocktailDetailResponse,NetworkServiceError>) in
                
                switch result{
                case .success(let response) :
                    DispatchQueue.main.async {
                        single(.success(response.drinks[0]))
                        self?.cocktailSummary = CocktailSummary(cocktailDetail: response.drinks[0])
                    }
                case .failure(let error) :
                    DispatchQueue.main.async {
                        single(.failure(error))
                    }
                }
                
            }
            
            return disposable
        }
        
    }
    
    func saveOrDeleteDrink() -> Single<CocktailState>{
        
        return Single.create { single in
            let disposable = Disposables.create()
            
            if self.isSaved(){
                self.databaseManager.deleteCocktail(cocktail: self.cocktailSummary!)
                single(.success(.Deleted))
            }else{
                self.databaseManager.saveCocktail(cocktail: self.cocktailSummary!) { error in
                    if let error = error {
                        single(.failure(error))
                    }else{
                        single(.success(.Saved))
                    }
                }
            }
        return disposable
        }
    
    }
    
    func isSaved() -> Bool{
        return self.databaseManager.getCocktail(id: self.drinkID) != nil ? true : false
    }
    
}
