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
    let results: [Character]?
}

struct Character: Identifiable, Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics: Comics?
    let series: Series?
    let stories: Stories?
    let events: Events?
    let urls: [CharacterURL]?
}

struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicItem]?
    let returned: Int?
}

struct ComicItem: Codable {
    let resourceURI: String?
    let name: String?
}

struct Series: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [SeriesItem]?
    let returned: Int?
}

struct SeriesItem: Codable {
    let resourceURI: String?
    let name: String?
}

struct Stories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoryItem]?
    let returned: Int?
}

struct StoryItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

struct Events: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [EventItem]?
    let returned: Int?
}

struct EventItem: Codable {
    let resourceURI: String?
    let name: String?
}

struct CharacterURL: Codable {
    let type: String?
    let url: String?
}
