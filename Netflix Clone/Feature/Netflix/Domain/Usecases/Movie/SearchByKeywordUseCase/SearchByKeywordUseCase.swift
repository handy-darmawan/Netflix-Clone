//
//  SearchByKeywordUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class SearchByKeywordUseCase: MovieUseCase, SearchByKeywordUseCaseProtocol {
    func execute(with keyword: String) async throws -> [Movie] {
        try await movieRepository.searchByKeyword(keyword)
    }
}
