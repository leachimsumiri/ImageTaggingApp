//
//  ApiResponse.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 12.01.22.
//

import Foundation

struct ApiResponse: Decodable {
    let status: String
    let keywords: [Keyword]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case keywords = "keywords"
    }
}
