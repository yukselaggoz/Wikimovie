//
//  Utility.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 3.11.2020.
//

import Foundation

class Utility {
    let storedMoviesKey = "KEY_STORED_MOVIES"
    let userDefault = UserDefaults.standard
    
    func addToFavoriteMovies(movieId: Int) -> Void {
        var favoriteMovies = userDefault.array(forKey: storedMoviesKey) as? [Int] ?? [Int]()
        
        favoriteMovies.append(movieId)
        userDefault.set(favoriteMovies, forKey: storedMoviesKey)
        userDefault.synchronize()
    }
    
    func removeFromFavoriteMovies(movieId: Int) -> Void {
        var favoriteMovies = userDefault.array(forKey: storedMoviesKey) as? [Int]
        
        if favoriteMovies == nil {
            
        } else {
            if let index = favoriteMovies!.firstIndex(of: movieId) {
                favoriteMovies?.remove(at: index)
                userDefault.set(favoriteMovies, forKey: storedMoviesKey)
            }
        }
        userDefault.synchronize()
    }
    
    func isFavoriteMovie(movieId: Int) -> Bool{
        let favoriteMovies = userDefault.object(forKey: storedMoviesKey) as? [Int]
        
        if favoriteMovies == nil {
            return false
        } else {
            return favoriteMovies!.contains(movieId)
        }
    }
    
}
