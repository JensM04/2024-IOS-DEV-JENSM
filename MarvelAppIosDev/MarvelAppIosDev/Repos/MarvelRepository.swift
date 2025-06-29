//
//  MarvelRepository.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 02/01/2025.
//

import Foundation

class MarvelRepository: MarvelRepositoryProtocol {
    
    //
    func fetchCharacter(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        guard let url = createMarvelRequestURL(characterId: characterId) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                if let results = decodedData.data?.results, let character = results.first {
                    completion(.success(character))
                } else {
                    completion(.failure(NSError(domain: "No character found", code: 404, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchAllCharacters(page: Int, limit: Int, completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = createMarvelRequestURLForAllCharacters(page: page, limit: limit) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                completion(.success(decodedData.data?.results ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchComics(characterId: Int, completion: @escaping (Result<[Comic], Error>) -> Void) {
        guard let url = createMarvelRequestURLForComics(characterId: characterId) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                completion(.success(decodedData.data?.results ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchEvents(characterId: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
            guard let url = createMarvelRequestURLForEvents(characterId: characterId) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(EventDataWrapper.self, from: data)
                    completion(.success(decodedData.data.results ?? []))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func fetchSeries(characterId: Int, completion: @escaping (Result<[MarvelAppIosDev.Series], Error>) -> Void) {
        guard let url = createMarvelRequestURLForSeries(characterId: characterId) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(SeriesDataWrapper.self, from: data)
                completion(.success(decodedData.data.results ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchAllComics(page: Int, limit: Int, completion: @escaping (Result<[Comic], Error>) -> Void) {
        guard let url = createMarvelRequestURLForAllComics(page: page, limit: limit) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                completion(.success(decodedData.data?.results ?? []))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
