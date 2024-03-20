//
//  GetTopRatedUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class GetTopRatedMoviesUseCase: MovieUseCase, MovieActionUseCaseProtocol {
    func execute() async throws -> [Movie]  {
        try await movieRepository.getTopRated()
    }
}
