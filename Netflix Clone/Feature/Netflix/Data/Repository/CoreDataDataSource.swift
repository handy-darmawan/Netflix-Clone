//
//  CoreDataDataSource.swift
//  Netflix Clone
//
//  Created by ndyyy on 08/03/24.
//

import Foundation
import CoreData

class CoreDataDataSource {
    private var coreDataManager = CoreDataManager.shared
    static let shared = CoreDataDataSource()
    
    func fetch(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        
        do {
            let results = try coreDataManager.context.fetch(request)
            let movies = results.map { Movie.toModel($0) }
            completion(.success(movies))
        } catch {
            print("Error fetching data")
            completion(.failure(error))
        }
    }
    
    func save(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        //check to db, is there an existing movie
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: movie.id))
        guard let results = try? coreDataManager.context.fetch(request) else {
            return completion(.failure(NSError(domain: "Error fetching data", code: 0, userInfo: nil)))
        }

        if results.isEmpty {
            let _ = movie.toEntity(context: coreDataManager.context)
            
            do {
                try coreDataManager.saveContext()
                completion(.success(()))
            } catch {
                print("Error saving data")
                completion(.failure(error))
            }
        }
        else {
            completion(.failure(NSError(domain: "Movie already exists", code: 0, userInfo: nil)))
        }
    }
    
    func delete(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = NSFetchRequest<Netflix>(entityName: "Netflix")
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: movie.id))
        guard let results = try? coreDataManager.context.fetch(request) else {
            return completion(.failure(NSError(domain: "Error fetching data", code: 0, userInfo: nil)))
        }

        do {
            results.forEach { coreDataManager.context.delete($0)}
            try coreDataManager.saveContext()

            completion(.success(()))
        } catch {
            print("Error deleting data")
            completion(.failure(error))
        }
    }
}
