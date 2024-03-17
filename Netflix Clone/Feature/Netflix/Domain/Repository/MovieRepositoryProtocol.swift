//
//  MovieRepositoryProtocol.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getTrendingMovies() async -> Result<[Movie], Error>
    func getTrendingTV() async -> Result<[Movie], Error>
    func getPopular() async -> Result<[Movie], Error>
    func getTopRated() async -> Result<[Movie], Error>
    func getUpcomingMovies() async -> Result<[Movie], Error>
    func getDiscoverMovies() async -> Result<[Movie], Error>
    func searchByKeyword(_ keyword: String) async -> Result<[Movie], Error>
    
    //Core Data
    func fetchMovies() async -> Result<[Movie], Error>
    func saveMovie(with movie: Movie) async -> Result<Void, Error>
    func deleteMovie(with movie: Movie) async -> Result<Void, Error>
}
