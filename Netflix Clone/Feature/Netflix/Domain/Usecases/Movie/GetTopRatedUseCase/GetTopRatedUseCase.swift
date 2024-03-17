//
//  GetTopRatedUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class GetTopRatedUseCase: MovieUseCase, MovieActionUseCaseProtocol {
    func execute() async -> Result<[Movie], Error> {
        return await movieRepository.getTopRated()
    }
}
