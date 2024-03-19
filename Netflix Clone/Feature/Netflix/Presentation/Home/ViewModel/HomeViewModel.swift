//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import UIKit
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


//MARK: - Enum
extension HomeViewModel {
    enum Sections: Int, CaseIterable {
        case header
        case trendingMovies
        case popular
        case trendingTV
        case upcomingMovies
        case topRated
        
        var rawValue: String {
            switch self {
            case .trendingMovies: return "Trending Movies"
            case .popular: return "Popular"
            case .trendingTV: return "Trending TV"
            case .upcomingMovies: return "Upcoming Movies"
            case .topRated: return "Top Rated"
            default: return ""
            }
        }
        
    //    var value: Int {
    //        switch self {
    //        case .trendingMovies: return 0
    //        case .popular: return 1
    //        case .trendingTV: return 2
    //        case .upcomingMovies: return 3
    //        case .topRated: return 4
    //        default: return 0
    //        }
    //    }
        
        var itemCount: Int {
            switch self {
            case .header: return 1
            default: return 3
            }
        }
        
        var groupHeight: NSCollectionLayoutDimension {
            let height = 1.0
            switch self {
            case .header: return .fractionalHeight(height/2)
            default: return .fractionalHeight(height/3)
            }
        }
        
        var groupWidth: NSCollectionLayoutDimension {
            let width = 1.0
            switch self {
            case .header: return .fractionalWidth(width)
            default: return .fractionalWidth(width+0.25)
            }
        }
    }
}
