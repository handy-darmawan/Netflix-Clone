//
//  GetMovieUseCaseProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol GetMovieUseCaseProtocol {
    func execute(with query: String) async -> Result<Youtube, Error>
}
