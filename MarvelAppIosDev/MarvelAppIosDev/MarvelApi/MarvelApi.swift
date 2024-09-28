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
    let publicKey = "298bc061a7fdc1797e00216968bfc829"
    let privateKey = "f58ec5eedc48f20a59adb7d12210d4ab80b468db"
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
    
    let urlString = "https://gateway.marvel.com/v1/public/characters/\(characterId)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    return URL(string: urlString)
}
