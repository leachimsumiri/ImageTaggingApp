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
    
    func uploadImage(imgData: Data, completionHandler: @escaping (String?, NSError?) -> ()) {
        let apiKey = "RmsP1fMKwriGr8NzNOxxuHdq"
        let apiSecret = "HaBGRbZXRIZBlQ9yCr9216McdThsVeyNPr3wUGwZ1pdc5BKl"
        let loginString = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
        let base64LoginString = loginString.base64EncodedString()
        let url = URL(string: "https://api.everypixel.com/v1/keywords?num_keywords=10")!
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"data\"; filename=\"data.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imgData)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let dataTask = Networking.session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            if let data = data {
                print("networking dataTask: DATA")
                
                /*let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(jsonData!)
                print("----")
                let json = jsonData as! ApiResponse //{
                    print(json)
                    */
                    let jsonDecoder = JSONDecoder()
                    let apiResponse = try! jsonDecoder.decode(ApiResponse.self, from: data)
                let keywords = apiResponse.keywords
                    //if let keywords = keywords {
                    keywords.forEach { keyword in
                        print("\(keyword.keyword) with score: \(keyword.score)")
                    }
                    //}
                    
                    /*print("------")
                    
                    print(json.keywords)
                    print(json.status)*/
                    /*print(json["keywords"]!)
                    print(type(of: json["keywords"]!))
                    print(json["keywords"] as? [Keyword] ?? "default value")
                    let keywords = json["keywords"] as! [Keyword]
                    keywords.forEach { keyword in
                        print("\(keyword.keyword) with score: \(keyword.score)")
                    }*/
                }
            //}
            
            if let response = response {
                print("networking dataTask: RESPONSE")
                print(response)
            }
            
            if let error = error {
                print("networking dataTask: ERROR")
                print(error)
            }
            
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
