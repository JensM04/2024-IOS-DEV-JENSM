//
//  ContentView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MarvelViewModel()

    var body: some View {
        VStack {
            if let character = viewModel.character {
                Text(character.name ?? "Unknown Character")
                    .font(.largeTitle)
                    .padding()
                
                if let description = character.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .padding()
                } else {
                    Text("No description available")
                        .font(.body)
                        .padding()
                }
                
                if let imageUrl = character.thumbnail?.fullPath, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Text("No image available")
                        .font(.caption)
                }

            } else {
                Text("Loading character...")
                    .onAppear {
                        viewModel.fetchCharacter(characterId: 1009610)
                    }
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}


import CryptoKit
import Foundation

func generateMarvelHash(timestamp: String, privateKey: String, publicKey: String) -> String {
    let toHash = "\(timestamp)\(privateKey)\(publicKey)"
    let hash = Insecure.MD5.hash(data: toHash.data(using: .utf8) ?? Data())
    return hash.map { String(format: "%02hhx", $0) }.joined()
}

func createMarvelRequestURL(characterId: Int) -> URL? {
    let publicKey = "298bc061a7fdc1797e00216968bfc829"
    let privateKey = "f58ec5eedc48f20a59adb7d12210d4ab80b468db"
    let timestamp = "\(Int(Date().timeIntervalSince1970))"
    let hash = generateMarvelHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)
    
    let urlString = "https://gateway.marvel.com/v1/public/characters/\(characterId)?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
    return URL(string: urlString)
}

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

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


import SwiftUI

class MarvelViewModel: ObservableObject {
    @Published var character: Character?

    func fetchCharacter(characterId: Int) {
        guard let url = createMarvelRequestURL(characterId: characterId) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                    DispatchQueue.main.async {
                        self.character = decodedData.data?.results.first
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }
        task.resume()
    }
}

