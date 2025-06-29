//
//  MarvelRepositoryProtocol.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 02/01/2025.
//


import Foundation

protocol MarvelRepositoryProtocol {
    func fetchCharacter(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void)
    func fetchAllCharacters(page: Int, limit: Int, completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchAllComics(page: Int, limit: Int, completion: @escaping (Result<[Comic], Error>) -> Void) 
    func fetchComics(characterId: Int, completion: @escaping (Result<[Comic], Error>) -> Void)
    func fetchEvents(characterId: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchSeries(characterId: Int, completion: @escaping (Result<[MarvelAppIosDev.Series], Error>) -> Void)
}
