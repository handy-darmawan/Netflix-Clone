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
    private let getMovieLinks: GetMovieUseCase
    private let movieRepository = MovieRepository.shared
    private let youtubeRepository = YoutubeRepository.shared
    
    var movies: [Movie] = []
    
    init() {
        getUpcomingMoviesUseCase = GetUpcomingMoviesUseCase(movieRepository: movieRepository)
        getMovieLinks = GetMovieUseCase(youtubeRepository: youtubeRepository)
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
