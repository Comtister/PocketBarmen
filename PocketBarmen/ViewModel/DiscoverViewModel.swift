//
//  DiscoverViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import Foundation
import RxSwift

class DiscoverViewModel : NetworkableViewModel{
    
    private var _loadingState : PublishSubject<Bool>
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
   
    override init() {
        self._loadingState = PublishSubject<Bool>()
    }
    
    func getCategories() -> Single<CategoryResponse>{
        return Single.create { [weak self] (single) -> Disposable in
            
            let disposable = Disposables.create()
            self?._loadingState.onNext(true)
            
            do{
                try NetworkServiceManager.shared.sendRequest(request: CategoryRequestModel(), completion: { (result : Result<CategoryResponse,NetworkServiceError>) in
                    
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let response) :
                            single(.success(response))
                            self?._loadingState.onNext(false)
                        case .failure(let error) :
                            single(.failure(error))
                            self?._loadingState.onNext(false)
                        }
                    }
                })
            }catch{
                DispatchQueue.main.async {
                    single(.failure(error))
                    self?._loadingState.onNext(false)
                }
            }
            return disposable
        }
        
    }
    
    
}
