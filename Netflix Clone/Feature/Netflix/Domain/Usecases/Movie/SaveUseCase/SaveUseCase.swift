//
//  SaveUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class SaveUseCase: MovieUseCase, MoviePersistenceUseCaseProtocol {
    func execute(with movie: Movie) async throws {
        try await movieRepository.saveMovie(with: movie)
    }
}
