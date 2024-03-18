//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import Foundation
import Combine

class HomeViewModel {
    private let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    private let getTrendingTVUseCase: GetTrendingTVUseCase
    private let getPopularMoviesUseCase: GetPopularMoviesUseCase
    private let getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    private let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    private let movieRepository = MovieRepository.shared
    
    var movies = CurrentValueSubject<[Movie], Never>([])
    //must be use 5 var? to trigger the homeview
    
    init() {
        getTrendingMoviesUseCase = GetTrendingMoviesUseCase(movieRepository: movieRepository)
        getTrendingTVUseCase = GetTrendingTVUseCase(movieRepository: movieRepository)
        getPopularMoviesUseCase = GetPopularMoviesUseCase(movieRepository: movieRepository)
        getTopRatedMoviesUseCase = GetTopRatedMoviesUseCase(movieRepository: movieRepository)
        getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(movieRepository: movieRepository)
    }
    
    func getTrendingMovies() async {
        do {
            let result = try await getTrendingMoviesUseCase.execute()
            movies.send(result)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getTrendingTV() async {
        do {
            let result = try await getTrendingTVUseCase.execute()
            movies.send(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getPopularMovies() async {
        do {
            let result = try await getPopularMoviesUseCase.execute()
            movies.send(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getTopRatedMovies() async {
        do {
            let result = try await getTopRatedMoviesUseCase.execute()
            movies.send(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUpcomingMovies() async {
        do {
            let result = try await getUpcomingMoviesUseCase.execute()
            movies.send(result)
        } catch {
            print(error.localizedDescription)
        }
    }
}
