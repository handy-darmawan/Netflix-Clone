//
//  DetailViewModel.swift
//  Netflix Clone
//
//  Created by ndyyy on 24/03/24.
//

import Foundation


class DetailViewModel {
    //MARK: - Attributes
    private let getMovieUseCase: GetMovieUseCase
    private let saveMovieUseCase: SaveUseCase
    private let youtubeRepository = YoutubeRepository.shared
    private let movieRepository = MovieRepository.shared
    
    init() {
        saveMovieUseCase = SaveUseCase(movieRepository: movieRepository)
        getMovieUseCase = GetMovieUseCase(youtubeRepository: youtubeRepository)
    }
}


//MARK: - Action
extension DetailViewModel {
    func saveMovie(with movie: Movie) async {
        do {
            try await saveMovieUseCase.execute(with: movie)
            await AlertUtility.showAlert(with: "Information", message: "Movie Saved")
        } catch(let error as LocalError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        }
        catch {}
    }
    
    func getYoutubeID(for movie: Movie) async -> String? {
        do {
            guard let title = movie.originalTitle ?? movie.originalName else { return nil }
            let result = try await getMovieUseCase.execute(with: "\(title) Trailer")
            return result.videoId
        } catch(let error as NetworkError) {
            await AlertUtility.showAlert(with: "Error", message: error.localizedDescription)
        }
        catch {}
        return nil
    }
}
