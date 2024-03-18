//
//  YoutubeRepository.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class YoutubeRepository: YoutubeRepositoryProtocol {
    static let shared = YoutubeRepository()
    private let networkDataSource = YoutubeNetworkDataSource()
    
    func getMovie(with query: String) async throws -> Youtube {
        return try await networkDataSource.getMovie(with: query)
    }
}
