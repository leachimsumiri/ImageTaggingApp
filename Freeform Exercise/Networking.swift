//
//  Networking.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 06.01.22.
//

import Foundation
import UIKit

class Networking {
    static let session = URLSession(configuration: .default)
    
    func uploadImage(imgBase64: String, completionHandler: @escaping (String?, NSError?) -> ()) {
        let apiKey = "acc_8e641ff4617a004"
        let apiSecret = "f3c5e5919c1007d5e7e2d6268b245e28"
        let url = URL(string: "https://api.imagga.com/v2/uploads")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(apiKey):\(apiSecret)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String : Any] = [
            "image_base64": imgBase64
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted]) else {
            /*DispatchQueue.main.async {
                completionHandler(nil, LoginError.serializeError, nil)
            }*/
            print("error encoding json data for http body parameters")
            return
        }
        
        request.httpBody = jsonData
        
        let dataTask = Networking.session.dataTask(with: request, completionHandler: { data, response, error in
            print(data!)
            print(response!)
            print(error!)
            /*if let data = data {
                let jsonDecoder = JSONDecoder()
                let user = try? jsonDecoder.decode(User.self, from: data)
                if let user = user {
                    Networking.loggedInUser = user
                    DispatchQueue.main.async {
                        completionHandler(user, nil, nil)
                    }
                    
                    return
                }
                
                let dataError = try? jsonDecoder.decode(LoginResponseError.self, from: data)
                if let dataError = dataError {
                    printErrorMessage(errorMessage: dataError.error.message, errorCode: dataError.error.code)
                }
                
                return
            }
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil, LoginError.unexpectedFormatError, nil)
            }*/
        })
        
        dataTask.resume()
    }
}
