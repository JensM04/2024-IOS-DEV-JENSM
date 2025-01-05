//
//  SideMenuOptionModel.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case characters
    case comics
    case lists
    
    var title: String {
        switch self {
        case .characters: return "Characters"
        case .comics: return "Comics"
        case .lists: return "Lists"
        }
    }
    
    var ImageName: String {
        switch self {
        case .characters: return "characters"
        case .comics: return "comics"
        case .lists: return "lists"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id : Int { return self.rawValue }
}
