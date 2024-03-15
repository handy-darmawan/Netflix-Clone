//
//  LocalDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func saveMovie(with movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) async
    func deleteMovie(with movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) async
}
