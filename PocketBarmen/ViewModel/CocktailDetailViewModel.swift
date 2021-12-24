//
//  CocktailDetailViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 7.12.2021.
//

import Foundation
import RxSwift

class CocktailDetailViewModel{
    
    private let drinkID : String
    
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
    
    
}
