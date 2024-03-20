//
//  MoviePersistenceUseCaseProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol MoviePersistenceUseCaseProtocol {
    func execute(with movie: Movie) async throws
}
