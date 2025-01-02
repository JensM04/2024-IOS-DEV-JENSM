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
}
