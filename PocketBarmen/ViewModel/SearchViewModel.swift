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
    
    var currentData : SearchResponse = SearchResponse()
    
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
        NetworkServiceManager.shared.sendRequest(request: CocktailsRequestModel(character: alphabetSequence[alphabetIndex])) { [weak self] (result : Result<SearchResponse,NetworkServiceError>) in
            
            switch result{
                case .success(let response) :
                    self?.alphabetIndex == 0 ? self?.currentData = response : self?.currentData.drinks.append(contentsOf: response.drinks)
                    
                    guard let currentData = self?.currentData else {return}
                    
                    let imageDispatchGroup = DispatchGroup()
                    
                    for (index , drink) in currentData.drinks.enumerated(){
                        
                        if drink.imageDownloadingState{
                            continue
                        }
                        
                        imageDispatchGroup.enter()
                        self?.getImage(cocktailSum: drink , completion: { (result) in
                            switch result{
                            case .success(let data) :
                                print(index)
                                self?.currentData.drinks[index].imageData = data
                                self?.currentData.drinks[index].imageDownloadingState = true
                                break
                            case .failure(let error) :
                                break
                            }
                            imageDispatchGroup.leave()
                        })
                    }
                    
                    imageDispatchGroup.wait()
                    
                    DispatchQueue.main.async {
                        self?._cocktails.onNext(currentData)
                        self?._loadingState.onNext(false)
                        self?.alphabetIndex += 1
                    }
                    
                case.failure(let error) :
                    DispatchQueue.main.async {
                        self?._cocktails.onError(error)
                        self?._loadingState.onNext(false)
                    }
            }
        
        }
    }
    
    private func getImage(cocktailSum : CocktailSummary , completion : @escaping (Result<Data,Error>) -> Void){
        
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkServiceManager.shared.imageRequest(url: cocktailSum.imageDownloadUrl) {(result) in
               
                switch result{
                case .success(let data) :
                    completion(Result.success(data))
                case .failure(let error) :
                    print("Burada \(error)")
                    completion(Result.failure(error))
                }
                
            }
        }
            
    }
    
    
}
