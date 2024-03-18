//
//  SearchByKeywordUseCaseProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol SearchByKeywordUseCaseProtocol {
    func execute(with keyword: String) async throws -> [Movie] 
}
