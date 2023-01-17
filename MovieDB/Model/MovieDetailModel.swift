//
//  MovieDetailModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 16.01.2023.
//

import Foundation

struct MovieDetailModel: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let revenue, runtime: Int
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var backdropUrl: String {
        return ApiConstant.baseImageUrl + (self.backdropPath ?? self.posterPath)
    }
    
    var categoriesString: String {
        let names = genres.map { $0.name }
        return names.joined(separator: ", ")
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
