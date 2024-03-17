//
//  MovieUseCase.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

class MovieUseCase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
}
