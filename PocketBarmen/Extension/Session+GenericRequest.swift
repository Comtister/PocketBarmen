//
//  Session+GenericRequest.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 7.09.2021.
//

import Foundation
import Alamofire

extension Session{
    
    func request(request : NetRequestModel) throws -> DataRequest{
        
        return self.request(try! request.getRequestUrl(),method: request.httpMethod,parameters: request.body ,encoder: request.encoder,headers: request.httpHeaders,interceptor: nil,requestModifier: nil)
        
    }
    
}
