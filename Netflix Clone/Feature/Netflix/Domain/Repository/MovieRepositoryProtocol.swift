//
//  MovieRepositoryProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getTrendingMovies() async throws -> [Movie]
    func getTrendingTV() async throws -> [Movie]
    func getPopular() async throws -> [Movie]
    func getTopRated() async throws -> [Movie]
    func getUpcomingMovies() async throws -> [Movie]
    func getDiscoverMovies() async throws -> [Movie]
    func searchByKeyword(_ keyword: String) async throws -> [Movie]
    
    //Core Data
    func fetchMovies() async throws -> [Movie]
    func saveMovie(with movie: Movie) async throws
    func deleteMovie(with movie: Movie) async throws
}
