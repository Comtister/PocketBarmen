//
//  CoctailDBService.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 7.09.2021.
//

import Foundation
import Alamofire

class NetworkServiceManager {
    
    static let shared : NetworkServiceManager = NetworkServiceManager()
    private let session : Session
    
    private init(){
        let sessionConfig = Session.default.sessionConfiguration
        sessionConfig.timeoutIntervalForRequest = 6
        self.session = Session(configuration : sessionConfig)
    }
    
    func sendRequest<T : Codable>(request : NetRequestModel , completion : @escaping (Result<T,NetworkServiceError>) -> Void) throws{
        
        try! session.request(request: request).validate(statusCode: 200...300).response(queue:.global(qos: .userInitiated),completionHandler: { (response) in
            
            switch response.result{
            
            case .success(let data) :
                guard let data = data else { completion(Result.failure(NetworkServiceError.NetworkError)) ; return }
                
                let responseModel = NetResponseModel<T>(data: data)
                
                guard let object = responseModel.object else {completion(Result.failure(NetworkServiceError.NetworkError)) ; return}
                
                completion(Result.success(object))
                
            case .failure(let error) :
                print(error)
                let generalizedError = error.responseCode == nil ? NetworkServiceError.NetworkError : NetworkServiceError.ServerError
                completion(Result.failure(generalizedError))
            }
            
        })
        
    }
    
}
