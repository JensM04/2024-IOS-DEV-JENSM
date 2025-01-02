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
    @Published var isLoading: Bool = false
    
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }

    func fetchCharacter(characterId: Int) {
        repository.fetchCharacter(characterId: characterId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let character):
                    self?.character = character
                case .failure(let error):
                    print("Error fetching character: \(error)")
                }
            }
        }
    }

    func fetchAllCharacters() {
        isLoading = true
        repository.fetchAllCharacters { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let characters):
                    self?.characters = characters
                case .failure(let error):
                    print("Error fetching characters: \(error)")
                }
            }
        }
    }
}
