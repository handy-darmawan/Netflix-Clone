//
//  MovieNetworkDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol MovieNetworkDataSourceProtocol {
    func getTrendingMovies() async throws -> [Movie]
    func getTrendingTV() async throws -> [Movie]
    func getPopular() async throws -> [Movie]
    func getTopRated() async throws -> [Movie]
    func getUpcomingMovie() async throws -> [Movie]
    func getDiscoverMovies() async throws -> [Movie]
    func searchByKeyword(keyword: String) async throws -> [Movie]
}
