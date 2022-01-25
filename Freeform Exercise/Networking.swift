//
//  Networking.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 06.01.22.
//

import Foundation
import UIKit

class Networking {
    let mockApiResponse = MockApiResponse()
    static let session = URLSession(configuration: .default)
    
    func uploadImage(imgData: Data, completionHandler: @escaping ([Keyword]?) -> ()) {
        //let apiKey = "RmsP1fMKwriGr8NzNOxxuHdq"
        let apiKey = "just_wrong" // wrong api key for mocking
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
            handleSuccessfulResponse(keywords: self.mockApiResponse.keywords!) // mock
            return
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let apiResponse = try! jsonDecoder.decode(ApiResponse.self, from: data)
                // TODO handle error
                handleSuccessfulResponse(keywords: apiResponse.keywords)
            }
            
            if let response = response {
                print("networking dataTask: RESPONSE")
                print(response)
            }
            
            if let error = error {
                print("networking dataTask: ERROR")
                print(error)
            }
        })
        
        dataTask.resume()
        
        func handleSuccessfulResponse(keywords: [Keyword]) {
            completionHandler(keywords)
        }
    }
}
