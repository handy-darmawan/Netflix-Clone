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
    
    ///Get movie detail
    func getMovie(with query: String, completion: @escaping (Result<YoutubeVideo, Error>) -> Void) async {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(networkManager.baseURL)q=\(query)&key=\(networkManager.API_KEY)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let results = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                    completion(.success(results.items[0]))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
}
