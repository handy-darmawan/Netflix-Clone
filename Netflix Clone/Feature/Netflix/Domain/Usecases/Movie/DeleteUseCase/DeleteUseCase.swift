//
//  DeleteUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class DeleteUseCase: MovieUseCase, MoviePersistenceUseCaseProtocol {
    func execute(with movie: Movie) async throws {
        try await movieRepository.deleteMovie(with: movie)
    }
}
