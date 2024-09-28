//
//  Thumbnail.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation

//voor de foto
struct Thumbnail: Codable {
    let path: String?
    let `extension`: String?
    
    var fullPath: String? {
        guard let path = path, let ext = `extension` else { return nil }
        
        if path.hasPrefix("http://") {
            return path.replacingOccurrences(of: "http://", with: "https://") + "." + ext
        } else if path.hasPrefix("https://") {
            return path + "." + ext
        } else {
            return "https://\(path)." + ext
        }
    }
}
