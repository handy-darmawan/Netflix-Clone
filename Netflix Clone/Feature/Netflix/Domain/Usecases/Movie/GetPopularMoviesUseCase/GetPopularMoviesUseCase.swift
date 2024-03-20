//
//  GetPopularUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class GetPopularMoviesUseCase: MovieUseCase, MovieActionUseCaseProtocol {
    func execute() async throws -> [Movie] {
        try await movieRepository.getPopular()
    }
}
