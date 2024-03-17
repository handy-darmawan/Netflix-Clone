//
//  MovieActionUseCaseProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 15/03/24.
//

import Foundation

protocol MovieActionUseCaseProtocol {
    func execute() async -> Result<[Movie], Error>
}
