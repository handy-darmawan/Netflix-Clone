//
//  Movie.swift
//  Netflix Clone
//
//  Created by ndyyy on 28/02/24.
//

import Foundation
import CoreData

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

extension Movie {
    func toEntity(context: NSManagedObjectContext) -> Netflix {
        let entity = Netflix(context: context)
        entity.id = Int32(id)
        entity.mediaType = mediaType
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.posterPath = posterPath
        entity.voteCount = Int32(voteCount ?? 0)
        entity.releaseDate = releaseDate
        entity.voteAverage = voteAverage ?? 0
        return entity
    }
    
    static func toModel(_ netflixItem: Netflix) -> Self {
        return Movie(id: Int(netflixItem.id),
                     mediaType: netflixItem.mediaType,
                     originalName: netflixItem.originalName,
                     originalTitle: netflixItem.originalTitle,
                     overview: netflixItem.overview,
                     posterPath: netflixItem.posterPath,
                     voteCount: Int(netflixItem.voteCount),
                     releaseDate: netflixItem.releaseDate,
                     voteAverage: netflixItem.voteAverage)
    }
    
}
