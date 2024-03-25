//
//  DetailViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 24/03/24.
//

import Foundation


class DetailViewModel {
    //MARK: Attributes
    private let getMovieUseCase: GetMovieUseCase
    private let saveMovieUseCase: SaveUseCase
    private let youtubeRepository = YoutubeRepository.shared
    private let movieRepository = MovieRepository.shared
    
    init() {
        saveMovieUseCase = SaveUseCase(movieRepository: movieRepository)
        getMovieUseCase = GetMovieUseCase(youtubeRepository: youtubeRepository)
    }
}


//MARK: Actions
extension DetailViewModel {
    func saveMovie(with movie: Movie) async {
        do {
            try await saveMovieUseCase.execute(with: movie)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getYoutubeID(for movie: Movie) async -> String? {
        do {
            guard let title = movie.originalTitle ?? movie.originalName else { return nil }
            let result = try await getMovieUseCase.execute(with: "\(title) Trailer")
            return result.videoId
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
