//
//  Event.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 04/01/2025.
//

struct EventDataWrapper: Decodable {
    let data: EventDataContainer
}

struct EventDataContainer: Decodable {
    let results: [Event]
}

struct Event: Identifiable, Decodable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: Thumbnail?
    let start: String
    let end: String
}
