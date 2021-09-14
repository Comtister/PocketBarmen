//
//  NetworkMonitor.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 8.09.2021.
//

import Foundation
import Network

class NetworkMonitor{
    
    static let networkMonitor = NetworkMonitor()
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor : NWPathMonitor
    
    public private(set) var  isConnected : Bool = false
    
    private init(){
        
        self.monitor = NWPathMonitor()
        
    }
    
    func startMonitoring(){
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
           
            if path.status == .satisfied{
                self?.isConnected = true
            }else{
                self?.isConnected = false
            }
            
            let networkStateNotification = Notification(name: Notification.Name.NetworkStateNotification,userInfo: ["state" : self?.isConnected as Any])
            NotificationCenter.default.post(networkStateNotification)
            
        }
        
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
    
}
