//
//  DownloadViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 20/03/24.
//

import Foundation

class DownloadViewModel {
    enum Sections { case download }
    
    private let fetchMoviesUseCase: FetchUseCase
    private let deleteMovie: DeleteUseCase
    private let movieRepository = MovieRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        fetchMoviesUseCase = FetchUseCase(movieRepository: movieRepository)
        deleteMovie = DeleteUseCase(movieRepository: movieRepository)
    }
}

extension DownloadViewModel {
    func onLoad() async {
        await fetchMovies()
    }
}

//MARK: - Actions
extension DownloadViewModel {
    private func fetchMovies() async {
        do {
            let results = try await fetchMoviesUseCase.execute()
            movies = results
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteMovie(with movie: Movie) async {
        do {
            try await deleteMovie.execute(with: movie)
        } catch {
            print(error.localizedDescription)
        }
    }
}
