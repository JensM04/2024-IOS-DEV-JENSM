//
//  Comic.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 04/01/2025.
//

import Foundation

struct ComicDataWrapper: Decodable {
    let code: Int?
    let status: String?
    let data: ComicDataContainer?
}

struct ComicDataContainer: Decodable {
    let results: [Comic]?
}

struct Comic: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Thumbnail?
    let urls: [ComicURL]?
}

struct ComicURL: Decodable {
    let type: String? 
    let url: String?
}
