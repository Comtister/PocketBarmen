//
//  FavoritesViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 16.02.2022.
//

import Foundation
import RxSwift
import RealmSwift

class FavoritesViewModel{
    
    enum FavoriteDatasState{
        case DataFound , DataNotFound
    }
    
    private(set) var cocktails : Results<CocktailSummary>?
    
    private let _loadingState : PublishSubject<Bool>
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    private(set) var cocktailsCount : Int = 0
    
    init(){
        self._loadingState = PublishSubject<Bool>()
    }
    
    func getDatas() -> Single<FavoriteDatasState>{
        _loadingState.onNext(true)
        return Single.create { [weak self] single in
            let disposable = Disposables.create()
            
            DatabaseManager.shared.getFavoriteCocktails { cocktailSummaryArray in
                
                guard let cocktailSummaryArray = cocktailSummaryArray else {
                    self?._loadingState.onNext(false)
                    return single(.failure(DatabaseError.DataNotFound))
                }
                self?._loadingState.onNext(false)
                self?.cocktails = cocktailSummaryArray
                single(.success(FavoriteDatasState.DataFound))
            }
            
            return disposable
        }
        
    }
    
}
