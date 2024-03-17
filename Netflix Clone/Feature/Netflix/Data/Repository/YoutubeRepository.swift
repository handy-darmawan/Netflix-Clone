//
//  YoutubeRepository.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class YoutubeRepository: YoutubeRepositoryProtocol {
    private let networkDataSource = YoutubeNetworkDataSource()
    private var result: Result<YoutubeVideo, Error>?
    
    func getMovie(with query: String) async -> Result<YoutubeVideo, Error> {
        await networkDataSource.getMovie(with: query) { self.result = $0 }
        return result ?? .failure(APIError.failedToGetData)
    }
}
