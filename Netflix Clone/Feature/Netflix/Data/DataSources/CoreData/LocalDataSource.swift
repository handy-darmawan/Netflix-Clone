//
//  LocalDataSource.swift
//  Netflix Clone
//
//  Created by ndyyy on 08/03/24.
//

import Foundation
import CoreData

class LocalDataSource: LocalDataSourceProtocol {
    static let shared = LocalDataSource()
    private let coreDataManager = CoreDataManager.shared
    
    func fetchMovies() async throws -> [Movie] {
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        do {
            let results = try coreDataManager.context.fetch(request)
            let movies = results.map { Movie.toModel($0) }
            return movies
        } catch {
            throw LocalError.failedToGetData
        }
    }
    
    func saveMovie(with movie: Movie) async throws {
        //check to db, is there an existing movie
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: movie.id))
        guard let results = try? coreDataManager.context.fetch(request) else {
            throw LocalError.failedToQueryData
        }

        if results.isEmpty {
            let _ = movie.toEntity(context: coreDataManager.context)
            do {
                try coreDataManager.saveContext()
            } catch {
                throw LocalError.failedToSaveData
            }
        }
        else {
            throw LocalError.movieAlreadyExists
        }
    }
    
    func deleteMovie(with movie: Movie) async throws {
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: movie.id))
        guard let results = try? coreDataManager.context.fetch(request) else { throw LocalError.failedToQueryData }

        do {
            results.forEach { coreDataManager.context.delete($0) }
            try coreDataManager.saveContext()
        } catch {
            throw LocalError.failedToDeleteData
        }
    }
}
