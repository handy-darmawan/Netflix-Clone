//
//  APIManager.swift
//  Netflix Clone
//
//  Created by ndyyy on 28/02/24.
//

import Foundation

struct Constants {
    static let API_KEY = "9943c87add787cf0d01cb9c33aa93d13"
    static let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
}

enum APIError: Error {
    case failedToGetData
    
    var localizedDescription: String {
        switch self {
        case .failedToGetData:
            return "Failed to get data"
        }
    }
}

class APIManager {
    static let shared = APIManager()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.API_KEY)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func getTrendingTv(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/tv/day?api_key=\(Constants.API_KEY)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }    
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func getUpcomingMovie(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
}
