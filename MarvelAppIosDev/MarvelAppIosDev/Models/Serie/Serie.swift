//
//  Serie.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 05/01/2025.
//

struct Serie: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [SeriesItem]?
    let returned: Int?
}

struct SeriesDataWrapper: Codable {
    let data: SeriesDataContainer
}

struct SeriesDataContainer: Codable {
    let results: [Series]
}
