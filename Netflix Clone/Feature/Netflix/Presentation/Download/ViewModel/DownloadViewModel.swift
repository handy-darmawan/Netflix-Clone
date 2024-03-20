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
    private let saveMovie: SaveUseCase
    private let deleteMovie: DeleteUseCase
    private let getMovieLinks: GetMovieUseCase
    private let movieRepository = MovieRepository.shared
    private let youtubeRepository = YoutubeRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        getMovieLinks = GetMovieUseCase(youtubeRepository: youtubeRepository)
        fetchMoviesUseCase = FetchUseCase(movieRepository: movieRepository)
        saveMovie = SaveUseCase(movieRepository: movieRepository)
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
    
    func saveMovie(with movie: Movie) async {
        do {
            try await saveMovie.execute(with: movie)
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
