//
//  MarvelCharacter.swift
//  MarvelDex
//
//  Created by Deven Day on 9/26/20.
//

import Foundation

struct TopLevelObject: Codable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Codable {
    let results: [MarvelCharacter]
}

struct MarvelCharacter: Codable {
    let name: String
    let description: String
    let thumbnailInfo: ThumbnailInfo
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnailInfo = "thumbnail"
    }
}

struct ThumbnailInfo: Codable {
    let path: URL
    let `extension`: String
}
