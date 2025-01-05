//
//  MarvelApi.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation
import CryptoKit

private let publicKey = "b0053c7d8115fc8b9868a0cb40f17472"
private let privateKey = "d2c93d16ab0626b307a76b1580bacf192be50eb2"

func generateMarvelHash(timestamp: String) -> String {
    let toHash = "\(timestamp)\(privateKey)\(publicKey)"
    let hash = Insecure.MD5.hash(data: toHash.data(using: .utf8) ?? Data())
    return hash.map { String(format: "%02hhx", $0) }.joined()
}

//baseurl
private func createBaseMarvelURL(endpoint: String, additionalQuery: String? = nil) -> URL? {
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp)
    
    var urlString = "https://gateway.marvel.com/v1/public/\(endpoint)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    
    if let additionalQuery = additionalQuery {
        urlString += "&\(additionalQuery)"
    }
    
    return URL(string: urlString)
}

//get 1 character
func createMarvelRequestURL(characterId: Int) -> URL? {
    createBaseMarvelURL(endpoint: "characters/\(characterId)")
}

//get alle characters
func createMarvelRequestURLForAllCharacters(page: Int, limit: Int) -> URL? {
    let offset = (page - 1) * limit
    let query = "limit=\(limit)&offset=\(offset)"
    return createBaseMarvelURL(endpoint: "characters", additionalQuery: query)
}

//get alle comics
func createMarvelRequestURLForAllComics(page: Int, limit: Int) -> URL? {
    let offset = (page - 1) * limit
    let query = "limit=\(limit)&offset=\(offset)"
    return createBaseMarvelURL(endpoint: "comics", additionalQuery: query)
}

//get alle comics voor 1 character
func createMarvelRequestURLForComics(characterId: Int) -> URL? {
    createBaseMarvelURL(endpoint: "characters/\(characterId)/comics")
}

//get alle events voor 1 character
func createMarvelRequestURLForEvents(characterId: Int) -> URL? {
    createBaseMarvelURL(endpoint: "characters/\(characterId)/events")
}

//get alle series voor 1 character
func createMarvelRequestURLForSeries(characterId: Int) -> URL? {
    createBaseMarvelURL(endpoint: "characters/\(characterId)/series")
}


