//
//  MovieRepository.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class MovieRepository: MovieRepositoryProtocol {
    static let shared = MovieRepository()
    private let networkDataSource = MovieNetworkDataSource()
    private let localDataSource = LocalDataSource()
    
  
    func getTrendingMovies() async throws -> [Movie] {
       return try await networkDataSource.getTrendingMovies()
    }
    
    func getTrendingTV() async throws -> [Movie] {
        return try await networkDataSource.getTrendingTV()
    }
    
    func getPopular() async throws -> [Movie] {
        return try await networkDataSource.getPopular()
    }
    
    func getTopRated() async throws -> [Movie] {
        return try await networkDataSource.getTopRated()
    }
    
    func getUpcomingMovies() async throws -> [Movie] {
        return try await networkDataSource.getUpcomingMovie()
    }
    
    func getDiscoverMovies() async throws -> [Movie] {
        return try await networkDataSource.getDiscoverMovies()
    }
    
    func searchByKeyword(_ keyword: String) async throws -> [Movie] {
        return try await networkDataSource.searchByKeyword(keyword: keyword)
    }
}

//Core Data
extension MovieRepository {
    func fetchMovies() async throws -> [Movie] {
        return try await localDataSource.fetchMovies()
    }
    
    func saveMovie(with movie: Movie) async throws {
        return try await localDataSource.saveMovie(with: movie)
    }
    
    func deleteMovie(with movie: Movie) async throws {
        return try await localDataSource.deleteMovie(with: movie)
    }
}
