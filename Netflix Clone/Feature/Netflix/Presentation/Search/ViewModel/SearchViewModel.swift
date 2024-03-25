//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 20/03/24.
//

import UIKit

class SearchViewModel {
    enum Sections { case search }
    
    private let searchMoviesUseCase: SearchByKeywordUseCase
    private let getDiscoverMoviesUseCase: GetDiscoverMoviesUseCase
    private let movieRepository = MovieRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        searchMoviesUseCase = SearchByKeywordUseCase(movieRepository: movieRepository)
        getDiscoverMoviesUseCase = GetDiscoverMoviesUseCase(movieRepository: movieRepository)
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
            let results = try await searchMoviesUseCase.execute(with: query)
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
}
