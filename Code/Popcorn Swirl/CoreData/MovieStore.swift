//
//  MovieStore.swift
//  Popcorn Swirl
//
//  Created by Rafal Padberg on 09/01/2020.
//  Copyright © 2020 Rafal Padberg. All rights reserved.
//

import UIKit
import CoreData

class MovieStore {
    
    var movies: [Movie] = []
    
    static let shared = MovieStore()
    
    init() {
        loadAllData()
    }
    
    public func watchlistMovie(id: String, title: String?, isWatchlisted: Bool, isWatched: Bool, comment: String) {
        
        if id == "0" {
            return
        }
        
        if let movie = findMovie(with: id) {
            // Does exist -> Update movie
            movie.id = id
            if title != nil {
                movie.title = title
            }
            movie.isWatchlisted = isWatchlisted
            movie.isWatched = isWatched
            movie.hasComment = !comment.isEmpty
            movie.comment = comment
            movie.updateDate = Date()
            
            if !isWatchlisted && !isWatched && comment.isEmpty {
                // Can be deleted
                AppDelegate.context.delete(movie)
            }
        } else {
            // Does not exist -> Add new movie
            
            let movie = Movie(context: AppDelegate.context)
            movie.id = id
            movie.title = title
            movie.isWatchlisted = true
            movie.isWatched = isWatched
            movie.hasComment = !comment.isEmpty
            movie.comment = comment
            movie.creationDate = Date()
            movie.updateDate = Date()
            
            
            movies.append(movie)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    public func findMovie(with id: String) -> Movie? {
        return movies.first(where: { $0.id == id })
    }
    
    public func loadAllData() {
        
        var match: [Movie] = []
        let context = AppDelegate.context
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
//        let sorting = NSSortDescriptor(key: "date", ascending: true)
//        request.sortDescriptors = [sorting]
        
        do {
            match = try context.fetch(request)
        } catch {
        }
        self.movies = match
    }
}
