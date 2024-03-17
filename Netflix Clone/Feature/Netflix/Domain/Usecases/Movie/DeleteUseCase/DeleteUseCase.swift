//
//  DeleteUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class DeleteUseCase: MovieUseCase, MoviePersistenceUseCaseProtocol {
    func execute(with movie: Movie) async -> Result<Void, Error> {
        await movieRepository.deleteMovie(with: movie)
    }
}
