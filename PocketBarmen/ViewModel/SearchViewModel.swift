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
    var temporaryData : SearchResponse? = SearchResponse()
    
    let alphabetSequence : [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","y","z"]
    
    var alphabetIndex : Int = 0
    
    var searchState : Bool = false
    var searchOperations : [String :DispatchWorkItem] = [String : DispatchWorkItem]()
    
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
                    
                    self?.fillPhotos {
                        DispatchQueue.main.async {
                            self?._cocktails.onNext(currentData)
                            self?._loadingState.onNext(false)
                            self?.alphabetIndex += 1
                        }
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
                    completion(Result.failure(error))
                }
                
            }
        }
            
    }
    
    private func fillPhotos(completion : @escaping () -> Void){
        let imageDispatchGroup = DispatchGroup()
        
        for (index , drink) in currentData.drinks.enumerated(){
            
            if drink.imageDownloadingState{
                continue
            }
            
            imageDispatchGroup.enter()
            getImage(cocktailSum: drink , completion: { [weak self] (result) in
                switch result{
                case .success(let data) :
                    self?.currentData.drinks[index].imageData = data
                    self?.currentData.drinks[index].imageDownloadingState = true
                    break
                case .failure(let error) :
                    //Handle Error
                    break
                }
                imageDispatchGroup.leave()
            })
        }
        
        imageDispatchGroup.wait()
        completion()
    }
    
    func searchCocktail(searchText : String){
        
        let operationID = UUID().uuidString
        
        let searchWork = DispatchWorkItem { [weak self] in
            
            let request = SearchRequest(searchText: searchText)
            
            self?._loadingState.onNext(true)
            NetworkServiceManager.shared.sendRequest(request: request) { [weak self] (result : Result<SearchResponse,NetworkServiceError>) in
                
                guard let operationItem = self?.searchOperations[operationID] , !operationItem.isCancelled else{
                    print("cancelled")
                    return
                }
                
                switch result{
                case .success(let response) :
                   
                    guard let searchState = self?.searchState else {return}
                    guard let currentData = self?.currentData else {return}
                    
                    if !searchState{
                        self?.temporaryData = currentData
                    }
                    
                    self?.searchState = true
                    self?.currentData = response
                    print("fuck")
                    self?.fillPhotos {
                        DispatchQueue.main.async {
                            self?._cocktails.onNext(currentData)
                            self?._loadingState.onNext(false)
                        }
                    }
                case .failure(let error) :
                    print(error)
                    DispatchQueue.main.async {
                        guard let currentData = self?.currentData else {return}
                        self?.temporaryData = currentData
                        self?.currentData = SearchResponse()
                        self?._cocktails.onNext(currentData)
                        self?._loadingState.onNext(false)
                    }
                }
                
            }
        }
        
        if searchText.isEmpty{
            searchOperations.forEach { (ID , dispatchItem) in
                dispatchItem.cancel()
            }
            print("Boşta")
            currentData = temporaryData ?? SearchResponse()//Handle state
            temporaryData = nil
            searchState = false
            print("\(searchState) \(searchWork.isCancelled)")
            //searchOperations.removeAll()
            _cocktails.onNext(currentData)
            return
        }
        
        searchOperations[operationID] = searchWork
        searchWork.perform()
        
       
    }
    
    
}
