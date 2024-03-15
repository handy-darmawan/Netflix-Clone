//
//  MovieNetworkDataSourceProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol MovieNetworkDataSourceProtocol {
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func getTrendingTV(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func getUpcomingMovie(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) async
    func searchByKeyword(keyword: String, completion: @escaping (Result<[Movie], Error>) -> Void) async
}
