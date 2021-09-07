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
    
    private init(){
        
    }
    
    func sendRequest<T : Codable>(request : NetRequestModel , completion : @escaping (Result<T,Error>) -> Void) throws{
        
        try! AF.request(request: request).validate(statusCode: 200...300).response(completionHandler: { (response) in
            
            switch response.result{
            
            case .success(let data) :
                let object = NetResponseModel<T>(data: data!)
                completion(Result.success(object.object!))
                break
            case .failure(let error) :
                break
            }
            
        })
        
    }
    
}
