//
//  DiscoverViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 2.09.2021.
//

import Foundation
import RxSwift

class DiscoverViewModel{
    
    private var _loadingState : PublishSubject<Bool>
    private var _networkState : PublishSubject<Bool>
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    var networkState : Observable<Bool>{
        return _networkState
    }
    
    
  
    init() {
        self._loadingState = PublishSubject<Bool>()
        self._networkState = PublishSubject<Bool>()
        listenNetworkStatus()
    }
    
    private func listenNetworkStatus(){
        NotificationCenter.default.addObserver(forName: .NetworkStateNotification, object: nil, queue: nil) { [weak self] (notification) in
            let userInfo = notification.userInfo as! [String : Bool]
            self?._networkState.onNext(userInfo["state"]!)
            
        }
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
                            break
                        case .failure(let error) :
                            single(.failure(error))
                            self?._loadingState.onNext(false)
                            break
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
