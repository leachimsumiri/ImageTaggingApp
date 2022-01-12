//
//  Keyword.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 12.01.22.
//

import Foundation

struct Keyword: Decodable {
    let keyword: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case keyword = "keyword"
        case score = "score"
    }
}


/*
 sample data response everypixel
 
 ["status": ok, "keywords": [
 {
     keyword = nature;
     score = "0.9963446367958373";
 },
 {
     keyword = leaf;
     score = "0.9923241836022356";
 },
 {
     keyword = plant;
     score = "0.9911774563872999";
 },
 {
     keyword = "multi colored";
     score = "0.9576665169633503";
 },
 {
     keyword = outdoors;
     score = "0.9495950604592167";
 },
 {
     keyword = flower;
     score = "0.9318137092904007";
 },
 {
     keyword = "close-up";
     score = "0.9301507381605739";
 },
 {
     keyword = summer;
     score = "0.9023457957607128";
 },
 {
     keyword = "beauty in nature";
     score = "0.8906225989201223";
 },
 {
     keyword = "pink color";
     score = "0.7430859512903449";
 }
 ]
 ]
 */
