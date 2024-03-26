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
            movies = try await searchMoviesUseCase.execute(with: query)
        } catch(let error as NetworkError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        } catch {}
    }
    
    private func getDiscoverMovies() async {
        do {
            movies = try await getDiscoverMoviesUseCase.execute()
        } catch(let error as NetworkError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        } catch {}
    }
}
