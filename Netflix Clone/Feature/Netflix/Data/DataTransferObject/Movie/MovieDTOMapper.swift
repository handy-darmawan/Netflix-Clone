//
//  MovieDTOMapper.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import Foundation
import CoreData

struct MovieDTOMapper {
    static func map(_ dto: MovieDTO) -> Movie {
        return Movie(id: Int(dto.id),
                     mediaType: dto.mediaType,
                     originalName: dto.originalName,
                     originalTitle: dto.originalTitle,
                     overview: dto.overview,
                     posterPath: dto.posterPath,
                     voteCount: dto.voteCount,
                     releaseDate: dto.releaseDate,
                     voteAverage: dto.voteAverage)
    }
}

//Core Data
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
