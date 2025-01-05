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
    @Published var series: [SeriesItem] = []
    @Published var isLoading: Bool = false
    @Published var currentCharacterPage: Int = 1
    @Published var totalCharacterPages: Int = 75
    @Published var currentComicsPage: Int = 1
    private let charactersPerPage = 20
    @Published var comicsTotalPages: Int = 20
    private let comicsPerPage = 20
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
    
    func fetchAllComics(page: Int) {
        isLoading = true
        repository.fetchAllComics(page: page, limit: comicsPerPage) { [weak self] result in
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
    
    func fetchSeries(characterId: Int) {
        isLoading = true
        MarvelRepository().fetchSeries(characterId: characterId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let series):
                    self?.series = series.flatMap { $0.items ?? [] }
                case .failure:
                    self?.series = []
                }
            }
        }
    }
}
