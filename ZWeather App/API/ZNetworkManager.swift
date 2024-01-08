//
//  ZNetworkManager.swift
//  ZWeather App
//
//  Created by Dinesh G on 06/01/24.
//

import Foundation

class ZNetworkManager{
    
    ///API call for URL string
    func apiCall(with urlString: String) async throws -> NSDictionary? {
        guard let url = URL(string: urlString) else{return nil}
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as? HTTPURLResponse
            
            do{
                let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary ?? [:]
                let statusCode = httpResponse?.statusCode ?? 0
                if (200 ..< 300) ~= statusCode{
                    
                    return json
                }
                else{
                    var error: ZError
                    let message = "HTTP Error: \(HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? 0))"
                    if (statusCode == 403) {
                        error = ZError(message:message, response: httpResponse, type: .unauthenticated)
                    }else if (statusCode == 400) {
                        let errJSON = json["error"] as? [String:Any]
                        let msg = errJSON?["message"] as? String
                        error = ZError(message: msg, response: httpResponse, type: .http)
                    }else {
                        error = ZError(message: message, response: httpResponse, type: .http)
                    }
                    throw error
                }
            }catch{
                throw error
            }
            
        }catch{
            let description = error.localizedDescription
            if let error = error as? ZError{
                throw error
            }
            if let error = error as? URLError,
               (error.code  == URLError.Code.notConnectedToInternet ||
                error.code  == URLError.Code.cannotConnectToHost ||
                error.code  == URLError.Code.timedOut) {
                
                let error = ZError(message: description, type: .network)
                throw error
            } else {
                let error = ZError(message: description, type: .unexpected)
                throw error
            }
        }
        
    }
    
    
    
    
    
}
