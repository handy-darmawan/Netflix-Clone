//
//  Movie.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double?
}
