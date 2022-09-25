//
//  ApiResponseError.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 12.01.22.
//

import Foundation

struct ApiResponseError: Decodable {
    let message: String
    let status: String
}
