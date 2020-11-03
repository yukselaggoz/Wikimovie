//
//  Movie.swift
//  Wikimovie
//
//  Created by Yüksel Ağgöz on 2.11.2020.
//

import Foundation

struct Movie: Decodable {
    var popularity: Float?
    var voteCount: Int?
    var video: Bool?
    var posterPath: String?
    var movieId: Int?
    var adult: Bool?
    var backdropPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var title: String?
    var voteAvarage: Float?
    var overview: String?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case posterPath = "poster_path"
        case movieId = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case title = "title"
        case voteAvarage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
    }
}

struct Initial: Decodable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
}
