//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import UIKit

class HomeViewModel {
    private let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    private let getTrendingTVUseCase: GetTrendingTVUseCase
    private let getPopularMoviesUseCase: GetPopularMoviesUseCase
    private let getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    private let saveMovieUseCase: SaveUseCase
    private let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    private let movieRepository = MovieRepository.shared
    
    var trendingMovies: [Movie] = []
    var trendingTV: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var headerMovies: Movie?
    
    init() {
        getTrendingMoviesUseCase = GetTrendingMoviesUseCase(movieRepository: movieRepository)
        getTrendingTVUseCase = GetTrendingTVUseCase(movieRepository: movieRepository)
        getPopularMoviesUseCase = GetPopularMoviesUseCase(movieRepository: movieRepository)
        getTopRatedMoviesUseCase = GetTopRatedMoviesUseCase(movieRepository: movieRepository)
        getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(movieRepository: movieRepository)
        saveMovieUseCase = SaveUseCase(movieRepository: movieRepository)
    }
}


//MARK: Actions
extension HomeViewModel {
    func onLoad() async {
        await getTrendingMovies()
        await getTrendingTV()
        await getPopularMovies()
        await getTopRatedMovies()
        await getUpcomingMovies()
        
        headerMovies = trendingMovies.randomElement()
        headerMovies?.uuid += "_header"
    }
    
    func saveMovie(with movie: Movie) async {
        do {
            try await saveMovieUseCase.execute(with: movie)
        } catch {
            print(error.localizedDescription)
        }
    }
}


//MARK: Private Actions
private extension HomeViewModel {
    func getTrendingMovies() async {
        do {
            let results = try await getTrendingMoviesUseCase.execute()
            trendingMovies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getTrendingTV() async {
        do {
            let results = try await getTrendingTVUseCase.execute()
            trendingTV = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getPopularMovies() async {
        do {
            let results = try await getPopularMoviesUseCase.execute()
            popularMovies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getTopRatedMovies() async {
        do {
            let results = try await getTopRatedMoviesUseCase.execute()
            topRatedMovies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUpcomingMovies() async {
        do {
            let results = try await getUpcomingMoviesUseCase.execute()
            upcomingMovies = results
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
        
        var itemCount: Int {
            switch self {
            case .header: return 1
            default: return 3
            }
        }
        
        var groupHeight: NSCollectionLayoutDimension {
            let height = 0.9
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
