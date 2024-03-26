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
            movies = try await fetchMoviesUseCase.execute()
        } catch(let error as LocalError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        } catch {}
    }
    
    func deleteMovie(with movie: Movie) async {
        do {
            try await deleteMovie.execute(with: movie)
            await AlertUtility.showAlert(with: "Information", message: "Movie Deleted")
        } catch(let error as LocalError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        } catch {}
    }
}
