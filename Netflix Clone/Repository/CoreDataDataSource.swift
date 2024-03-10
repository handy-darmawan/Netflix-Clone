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
        let vehicle = NSFetchRequest<Netflix>(entityName: "Netflix")
        
        do {
            let results = try coreDataManager.context.fetch(vehicle)
            let movies = results.map { Movie.toModel($0) }
            completion(.success(movies))
        } catch {
            print("Error fetching data")
            completion(.failure(error))
        }
    }
    
    func save(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        let _ = movie.toEntity(context: coreDataManager.context)
        
        do {
            try coreDataManager.context.save()
            completion(.success(()))
        } catch {
            print("Error saving data")
            completion(.failure(error))
        }
    }
}
