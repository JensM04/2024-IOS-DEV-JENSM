//
//  MarvelApi.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation
import CryptoKit


func generateMarvelHash(timestamp: String, privateKey: String, publicKey: String) -> String {
    let toHash = "\(timestamp)\(privateKey)\(publicKey)"
    let hash = Insecure.MD5.hash(data: toHash.data(using: .utf8) ?? Data())
    return hash.map { String(format: "%02hhx", $0) }.joined()
}

//gebruikt marvel dev api, met mijn unieke keys voor het requesten voor data (in dit geval een character)
func createMarvelRequestURL(characterId: Int) -> URL? {
    let publicKey = "8ab5735c14907aa64e86a2ce365f2d2a"
    let privateKey = "37f5290edf7d0d00a744fa7a3217f365c8b75a96"
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
    
    let urlString = "https://gateway.marvel.com/v1/public/characters/\(characterId)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    return URL(string: urlString)
}

//alle characters
func createMarvelRequestURLForAllCharacters() -> URL? {
    let publicKey = "8ab5735c14907aa64e86a2ce365f2d2a"
    let privateKey = "37f5290edf7d0d00a744fa7a3217f365c8b75a96"
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
    
    let urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    return URL(string: urlString)
}

//alle comics
func createMarvelRequestURLForAllComics() -> URL? {
    let publicKey = "8ab5735c14907aa64e86a2ce365f2d2a"
    let privateKey = "37f5290edf7d0d00a744fa7a3217f365c8b75a96"
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
    
    let urlString = "https://gateway.marvel.com/v1/public/comics?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    return URL(string: urlString)
}

