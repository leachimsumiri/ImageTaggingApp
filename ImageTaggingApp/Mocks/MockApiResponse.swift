//
//  MockApiResponse.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 25.01.22.
//

import UIKit

class MockApiResponse {
    var keywords: [Keyword]?
    let response: String =
            """
                {
                "status": "ok",
                "keywords": [
                    {
                        "keyword": "nature",
                        "score": 0.9963446367958373
                    },
                    {
                        "keyword" : "leaf",
                        "score" : 0.9923241836022356
                    },
                    {
                        "keyword" : "plant",
                        "score" : 0.9911774563872999
                    },
                    {
                        "keyword" : "multi colored",
                        "score" : 0.9576665169633503
                    },
                    {
                        "keyword" : "outdoors",
                        "score" : 0.9495950604592167
                    }
                ]
            }
            """
    
    init() {
        let jsonDecoder = JSONDecoder()
        let apiResponse = try! jsonDecoder.decode(ApiResponse.self, from: self.response.data(using: .utf8)!)
        self.keywords = apiResponse.keywords
    }
}
