//
//  NetworkableViewModel.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 13.09.2021.
//

import Foundation
import RxSwift

class NetworkableViewModel{
    
    private var _networkState : PublishSubject<Bool>
    
    var networkState : Observable<Bool>{
        return _networkState
    }
    
    init() {
        self._networkState = PublishSubject<Bool>()
        listenNetworkStatus()
    }
    
    private func listenNetworkStatus(){
        NotificationCenter.default.addObserver(forName: .NetworkStateNotification, object: nil, queue: nil) { [weak self] (notification) in
            let userInfo = notification.userInfo as! [String : Bool]
            self?._networkState.onNext(userInfo["state"]!)
            
        }
    }
    
}
