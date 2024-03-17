//
//  YoutubeNetworkDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol YoutubeNetworkDataSourceProtocol {
    func getMovie(with query: String, completion: @escaping (Result<YoutubeVideo, Error>) -> Void) async
}
