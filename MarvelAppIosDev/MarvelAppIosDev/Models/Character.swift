//
//  Character.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}
