//
//  MovieRepository.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class MovieRepository: MovieRepositoryProtocol {
    private let networkDataSource = MovieNetworkDataSource()
    private let localDataSource = LocalDataSource()
    
    private var result: Result<[Movie],Error>?
    
    func getTrendingMovies() async -> Result<[Movie], Error> {
        await networkDataSource.getTrendingMovies { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func getTrendingTV() async -> Result<[Movie], Error> {
        await networkDataSource.getTrendingTV { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func getPopular() async -> Result<[Movie], Error> {
        await networkDataSource.getPopular { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func getTopRated() async -> Result<[Movie], Error> {
        await networkDataSource.getTopRated { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func getUpcomingMovies() async -> Result<[Movie], Error> {
        await networkDataSource.getUpcomingMovie { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func getDiscoverMovies() async -> Result<[Movie], Error> {
        await networkDataSource.getDiscoverMovies { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func searchByKeyword(_ keyword: String) async -> Result<[Movie], Error> {
        await networkDataSource.searchByKeyword(keyword: keyword) { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
}

//Core Data
extension MovieRepository {
    func fetchMovies() async -> Result<[Movie], Error> {
        await localDataSource.fetchMovies { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func saveMovie(with movie: Movie) async -> Result<Void, Error> {
        var result: Result<Void, Error>?
        await localDataSource.saveMovie(with: movie) { result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
    
    func deleteMovie(with movie: Movie) async -> Result<Void, Error> {
        var result: Result<Void, Error>?
        await localDataSource.deleteMovie(with: movie) { result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
}
