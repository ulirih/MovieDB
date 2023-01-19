//
//  PersonModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 19.01.2023.
//

import Foundation

struct PersonModel: Codable {
    let birthday, knownForDepartment: String
    let deathday: String?
    let id: Int
    let name: String
    let alsoKnownAs: [String]
    let gender: Int
    let biography: String
    let popularity: Double
    let placeOfBirth: String
    let profilePath: String?
    let adult: Bool
    let imdbID: String
    let homepage: String?
    
    var profileImageUrl: String {
        return ApiConstant.baseImageUrl + (self.profilePath ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }
}
