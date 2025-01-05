//
//  MarvelList.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 05/01/2025.
//

import Foundation
import SwiftData

@Model
class MarvelList {
    var name: String
    var characters: [Character]
    var createdAt: Date
    
    init(name: String) {
        self.name = name
        self.characters = []
        self.createdAt = Date()
    }
}
