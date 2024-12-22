//
//  MarvelViewModel.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation

class MarvelViewModel: ObservableObject {
    @Published var character: Character?
    @Published var characters: [Character] = []

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

    func fetchAllCharacters() {
        guard let url = createMarvelRequestURLForAllCharacters() else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                    DispatchQueue.main.async {
                        self.characters = decodedData.data?.results ?? []
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }
        task.resume()
    }
}
