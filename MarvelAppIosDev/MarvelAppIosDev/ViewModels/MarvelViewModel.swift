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
    @Published var comics: [Comic] = []
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 75 
    private let charactersPerPage = 20
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

    func fetchAllCharacters(page: Int) {
        isLoading = true
        repository.fetchAllCharacters(page: page, limit: charactersPerPage) { [weak self] result in
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
    
    func fetchComics(characterId: Int) {
        isLoading = true
        repository.fetchComics(characterId: characterId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let comics):
                    self?.comics = comics
                case .failure(let error):
                    print("Error fetching comics: \(error)")
                }
            }
        }
    }
    
    func fetchEvents(characterId: Int) {
            isLoading = true
            repository.fetchEvents(characterId: characterId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let events):
                        self?.events = events
                    case .failure(let error):
                        print("Error fetching events: \(error)")
                    }
                }
            }
        }
    }
