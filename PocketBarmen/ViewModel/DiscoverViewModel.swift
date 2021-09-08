//
//  DiscoverViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import Foundation
import RxSwift


class DiscoverViewModel {
    
    private var _categories : PublishSubject<CategoryResponse>
    private var _loadingState : PublishSubject<Bool>
    
    var categories : Observable<CategoryResponse>{
        return _categories
    }
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    init() {
        
        _categories = PublishSubject<CategoryResponse>()
        _loadingState = PublishSubject<Bool>()
    }
    
    func getCategories(){
        _loadingState.onNext(true)
        do{
           try NetworkServiceManager.shared.sendRequest(request: CategoryRequestModel()) { [weak self] (result : Result<CategoryResponse,Error>) in
             
            DispatchQueue.main.async {
                switch result{
                case .success(let responseData) :
                    self?._categories.onNext(responseData)
                    self?._loadingState.onNext(false)
                    break
                case .failure(let error) :
                    self?._categories.onError(error)
                    self?._loadingState.onNext(false)
                    break
                }
            }
            
            
            }
        }catch{
            //Handle error
            _categories.onError(error)
        }
       
    }
    
}
