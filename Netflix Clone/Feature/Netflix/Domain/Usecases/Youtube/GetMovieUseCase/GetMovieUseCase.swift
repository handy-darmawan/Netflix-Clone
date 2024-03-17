//
//  GetMovieUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class GetMovieUseCase: YoutubeUseCase, GetMovieUseCaseProtocol {
    func execute(with query: String) async -> Result<YoutubeVideo, Error> {
        await youtubeRepository.getMovie(with: query)
    }
}
