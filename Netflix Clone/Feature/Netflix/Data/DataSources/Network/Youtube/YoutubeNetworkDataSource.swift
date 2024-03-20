//
//  YoutubeNetworkDataSource.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class YoutubeNetworkDataSource: YoutubeNetworkDataSourceProtocol {
    private let networkManager: YoutubeNetworkManager
    
    init(networkManager: YoutubeNetworkManager = YoutubeNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    private func fetch(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw NetworkError.failedToCreateURL }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw NetworkError.failedToGetData
        }
    }
    
    private func decodeData(_ data: Data) throws -> Youtube {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let results = try decoder.decode(YoutubeResponse.self, from: data)
            let youtube = YoutubeDTOMapper.map(results.items[0].id)
            return youtube
        } catch {
            throw NetworkError.failedToGetData
        }
    }
    
    private func movieLink(from urlString: String) async throws -> Youtube {
        let data = try await fetch(from: urlString)
        return try decodeData(data)
    }
    
    ///Get movie detail
    func getMovie(with query: String) async throws -> Youtube {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw NetworkError.failedToAddPercentDecoding }
        let urlString = "\(networkManager.baseURL)q=\(query)&key=\(networkManager.API_KEY)"
        return try await movieLink(from: urlString)
    }
}
