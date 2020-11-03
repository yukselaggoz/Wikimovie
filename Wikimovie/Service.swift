//
//  Service.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 2.11.2020.
//

import Foundation
import Alamofire

class Service {
    
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w400"
    static let apiKey = "fd2b04342048fa2d5f728561866ad52a"
    let language = "en-US"
    
    typealias getMoviesCallback = (_ movies: [Movie]?, _ status: Bool, _ message: String) -> Void
    var callbackMovies: getMoviesCallback?
    typealias getMovieDetailCallback = (_ movies: Movie?, _ status: Bool, _ message: String) -> Void
    var callbackMovieDetail: getMovieDetailCallback?
    
    func getMovies(endPoint: String, page: Int) -> Void {
        let parameters = ["language": language, "api_key": Service.apiKey, "page": page] as [String : Any]
        
        AF.request(Service.baseUrl + endPoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callbackMovies?(nil, false, "")
                return
            }
            do {                
                let initial = try JSONDecoder().decode(Initial.self, from: data)
                let movies = initial.results
                self.callbackMovies?(movies, true, "")
                print("Movies: \(movies!)")
            }
            catch {
                self.callbackMovies?(nil, false, error.localizedDescription)
                print("Error \(error)")
            }
            
        }
    }
    
    func completionHandler(callback: @escaping getMoviesCallback) -> Void {
        self.callbackMovies = callback
    }
    
    func getMovieDetail(movieId endPoint: String) -> Void {
        let parameters = ["language": language, "api_key": Service.apiKey] as [String : Any]
        
        AF.request(Service.baseUrl + endPoint, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callbackMovieDetail?(nil, false, "")
                return
            }
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                self.callbackMovieDetail?(movie, true, "")
                print("Movies: \(movie)")
            }
            catch {
                self.callbackMovieDetail?(nil, false, error.localizedDescription)
                print("Error \(error)")
            }
            
        }
    }
    
    func completionHandlerMovieDetail(callback: @escaping getMovieDetailCallback) -> Void {
        self.callbackMovieDetail = callback
    }
    
}
