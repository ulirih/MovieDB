//
//  TrendingMovieModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation

struct TrendingModel: Codable, Hashable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String?
    let originalTitle: String?
    let overview, posterPath: String
    let mediaType: MediaType
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?
    
    var posterUrl: String {
        return ApiConstant.baseImageUrl + self.posterPath
    }
    
    var backdropUrl: String {
        return ApiConstant.baseImageUrl + self.backdropPath
    }
    
    var dateDisplay: String {
        return self.releaseDate ?? self.firstAirDate ?? ""
    }
    
    var nameDisplay: String {
        return self.title ?? self.name ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}
