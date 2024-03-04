//
//  Movie.swift
//  Netflix Clone
//
//  Created by ndyyy on 28/02/24.
//

import Foundation

struct Response: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
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
