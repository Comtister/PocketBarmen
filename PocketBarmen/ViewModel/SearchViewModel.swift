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
    private var _imageStatus : PublishSubject<IndexPath>
    
    var cocktails : Observable<SearchResponse>{
        return _cocktails
    }
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    var imageStatus : Observable<IndexPath>{
        return _imageStatus
    }
    
    var currentData : SearchResponse = SearchResponse()
    
    let alphabetSequence : [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","y","z"]
    
    var alphabetIndex = 0
    
    var downloadingImages : [IndexPath : CocktailSummary] = [:]
    
    override init() {
        self._cocktails = PublishSubject<SearchResponse>()
        self._loadingState = PublishSubject<Bool>()
        self._imageStatus = PublishSubject<IndexPath>()
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
                        self?.alphabetIndex == 0 ? self?.currentData = response : self?.currentData.drinks.append(contentsOf: response.drinks)
                        
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
    
    func setImage(cocktailSum : CocktailSummary , indexPath : IndexPath){
        
        guard downloadingImages[indexPath] == nil else {
            return
        }
        
        downloadingImages[indexPath] = cocktailSum
        NetworkServiceManager.shared.imageRequest(url: cocktailSum.imageUrl) { [weak self] (result) in
           
            switch result{
            case .success(let data) :
                
                self?.downloadingImages.removeValue(forKey: indexPath)
                self?.currentData.drinks[indexPath.row].imageData = data
                self?.currentData.drinks[indexPath.row].imageDownloadingState = true
                self?._imageStatus.onNext(indexPath)
                //Handle onNext
                print(data)
            case .failure(let error) :
                print("Burada \(error)")
                
            }
            
        }
        
    }
    
}
