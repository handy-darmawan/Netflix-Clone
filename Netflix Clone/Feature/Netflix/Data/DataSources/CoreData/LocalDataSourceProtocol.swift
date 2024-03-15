//
//  LocalDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchAll(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func save(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) async
    func delete(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) async
}
