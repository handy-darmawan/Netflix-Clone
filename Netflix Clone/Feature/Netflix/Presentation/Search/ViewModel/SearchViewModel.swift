//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 20/03/24.
//

import UIKit

class SearchViewModel {
    enum Sections { case search }
    
    private let SearchMoviesUseCase: SearchByKeywordUseCase
    private let getDiscoverMoviesUseCase: GetDiscoverMoviesUseCase
    private let getMovieLinks: GetMovieUseCase
    private let movieRepository = MovieRepository.shared
    private let youtubeRepository = YoutubeRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        SearchMoviesUseCase = SearchByKeywordUseCase(movieRepository: movieRepository)
        getDiscoverMoviesUseCase = GetDiscoverMoviesUseCase(movieRepository: movieRepository)
        getMovieLinks = GetMovieUseCase(youtubeRepository: youtubeRepository)
    }
}

extension SearchViewModel {
    func onLoad() async {
        await getDiscoverMovies()
    }
}

//MARK: - Actions
extension SearchViewModel {
    func searchMovies(with query: String) async {
        do {
            let results = try await SearchMoviesUseCase.execute(with: query)
            movies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getDiscoverMovies() async {
        do {
            let results = try await getDiscoverMoviesUseCase.execute()
            movies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getMovieDetail(for movie: Movie) async -> Youtube? {
        do {
            guard let title = movie.originalTitle ?? movie.originalName else { return nil }
            let result = try await getMovieLinks.execute(with: "\(title) Trailer")
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
