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
    case events
    case series
    
    var title: String {
        switch self {
        case .characters: return "Characters"
        case .comics: return "Comics"
        case .events: return "Events"
        case .series: return "Series"
        }
    }
    
    var ImageName: String {
        switch self {
        case .characters: return "characters"
        case .comics: return "comics"
        case .events: return "events"
        case .series: return "series"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id : Int { return self.rawValue }
}
