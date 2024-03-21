//
//  CoreDataService.swift
//  TMDB
//
//  Created by LAP15284 on 21/03/2024.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    
    private init() { }
    
    static let shared = CoreDataService()
    static let numPerPage = 20
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addMovieData(movie: Movie) {
        let fetchRequest = MovieLocal.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        do {
            let movies = try context.fetch(fetchRequest)
            let movieLocal = movies.first ?? MovieLocal(context: context)
            movieLocal.id = Int64(movie.id)
            movieLocal.title = movie.title
            movieLocal.poster = movie.poster
            movieLocal.date = movie.date
            movieLocal.voteAvg = movie.voteAvg
            
            do {
                try context.save()
            } catch {
                print("error-Saving data")
            }
        } catch {
            print("error-Check exist data")
        }
    }
    
    func fetchMovieData(page: Int, onSuccess: @escaping ([Movie]) -> Void) {
        do {
            let fetchRequest = MovieLocal.fetchRequest()
            fetchRequest.fetchLimit = CoreDataService.numPerPage
            fetchRequest.fetchOffset = CoreDataService.numPerPage*page
            let items = try context.fetch(fetchRequest)
            onSuccess(items.map { Movie(localObject: $0) })
        } catch {
            print("error-Fetching data")
        }
    }
    
    func searchMovieData(keyword: String, onSuccess: @escaping ([Movie]) -> Void) {
        do {
            let fetchRequest = MovieLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", keyword)
            let items = try context.fetch(fetchRequest)
            onSuccess(items.map { Movie(localObject: $0) })
        } catch {
            print("error-Fetching data")
        }
    }
    
    
    func deleteMovieLocal(movie: MovieLocal) {
        context.delete(movie)
        do {
            try context.save()
        } catch {
            print("error-Deleting data")
        }
    }
    
    func addImageData(path: String, data: Data?) {
        let fetchRequest = ImageLocal.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "path == %@", path)
        do {
            let imgs = try context.fetch(fetchRequest)
            let imageLocal = imgs.first ?? ImageLocal(context: context)
            imageLocal.path = path
            imageLocal.data = data
            do {
                try context.save()
            } catch {
                print("error-Saving data")
            }
        } catch {
            print("error-Check exist data")
        }
    }
    
    func getImageData(path: String) -> Data? {
        let fetchRequest = ImageLocal.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "path == %@", path)
        let imgs = try? context.fetch(fetchRequest)
        if let imageLocal = imgs?.first {
            return imageLocal.data
        }
        return nil
    }
        
    func addMovieDetailData(movie: MovieDetail) {
        let fetchRequest: NSFetchRequest<MovieDetailLocal> = MovieDetailLocal.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        do {
            let movies = try context.fetch(fetchRequest)
            let movieLocal = movies.first ?? MovieDetailLocal(context: context)
            //update instead of create new
            movieLocal.id = Int64(movie.id)
            movieLocal.title = movie.title
            movieLocal.poster = movie.poster
            movieLocal.date = movie.date
            movieLocal.voteAvg = movie.voteAvg
            movieLocal.backdrop = movie.backdrop
            movieLocal.overview = movie.overview
            movieLocal.budget = Int64(movie.budget)
            movieLocal.revenue = Int64(movie.revenue)
            movieLocal.genres = movie.genres as NSObject
            movieLocal.homepage = movie.homepage
            movieLocal.popularity = movie.popularity
            movieLocal.productionCompanies = movie.productionCompanies as NSObject
            movieLocal.productionCountries = movie.productionCountries as NSObject
            movieLocal.duration = Int64(movie.duration)
            movieLocal.languages = movie.languages as NSObject
            movieLocal.status = movie.status
            movieLocal.tagline = movie.tagline
            movieLocal.voteCount = Int64(movie.voteCount)
            if let collection = movie.collection {
                let localCollection = MovieCollectionLocal(context: context)
                localCollection.id = Int64(collection.id)
                localCollection.name = collection.name
                localCollection.poster = collection.poster
                localCollection.backdrop = collection.backdrop
                movieLocal.collection = localCollection
            } else {
                movieLocal.collection = nil
            }
            
            do {
                try context.save()
            } catch {
                print("error-Saving data")
            }
        } catch {
            print("error-Check exist data")
        }
    }
    
    func getMovieDetailData(movId: Int) -> MovieDetail? {
        let movId = Int64(movId)
        let fetchRequest: NSFetchRequest<MovieDetailLocal> = MovieDetailLocal.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", movId)
        let movies = try? context.fetch(fetchRequest)
        if let movieLocal = movies?.first {
            return MovieDetail(localObject: movieLocal)
        }
        return nil
    }
}
