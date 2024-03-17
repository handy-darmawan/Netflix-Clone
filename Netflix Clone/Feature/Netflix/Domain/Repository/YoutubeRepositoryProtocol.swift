//
//  YoutubeRepositoryProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol YoutubeRepositoryProtocol {
    func getMovie(with query: String) async -> Result<YoutubeVideo, Error>
}
