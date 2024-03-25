//
//  UpcomingViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 20/03/24.
//

import Foundation


class UpcomingViewModel {
    enum Sections { case upcoming }
    
    private let getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    private let movieRepository = MovieRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(movieRepository: movieRepository)
    }
}

extension UpcomingViewModel {
    func onLoad() async {
        await fetchUpcomingMovies()
    }
}

//MARK: - Actions
extension UpcomingViewModel {
    private func fetchUpcomingMovies() async {
        do {
            let results = try await getUpcomingMoviesUseCase.execute()
            movies = results
        } catch {
            print(error.localizedDescription)
        }
    }
}
