//
//  SearchViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 14.09.2021.
//

import Foundation
import RxSwift

class SearchViewModel: NetworkableViewModel {
    
    private var _cocktails : PublishSubject<SearchResponse>
    private var _loadingState : PublishSubject<Bool>
    
    var cocktails : Observable<SearchResponse>{
        return _cocktails
    }
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    var currentData : SearchResponse?
    
    let alphabetSequence : [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","y","z"]
    
    var alphabetIndex = 0
    
    override init() {
        self._cocktails = PublishSubject<SearchResponse>()
        self._loadingState = PublishSubject<Bool>()
    }
    
    func getCocktails(){
        
        if alphabetIndex >= alphabetSequence.count{
            return
        }
        
        self._loadingState.onNext(true)
        NetworkServiceManager.shared.sendRequest(request: CocktailsRequestModel(character: alphabetSequence[alphabetIndex])) { (result : Result<SearchResponse,NetworkServiceError>) in
            
            DispatchQueue.main.async { [weak self] in
                switch result{
                    case .success(let response) :
                        self?.alphabetIndex == 0 ? self?.currentData = response : self?.currentData?.drinks.append(contentsOf: response.drinks)
                        
                        guard let currentData = self?.currentData else {return}
                        
                        self?._cocktails.onNext(currentData)
                        self?._loadingState.onNext(false)
                        self?.alphabetIndex += 1
                        break
                    case.failure(let error) :
                        self?._cocktails.onError(error)
                        self?._loadingState.onNext(false)
                        break
                }
            }
        }
    }
    
}
