//
//  LocalDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchMovies() async throws -> [Movie]
    func saveMovie(with movie: Movie) async throws
    func deleteMovie(with movie: Movie) async throws
}
