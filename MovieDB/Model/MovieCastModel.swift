//
//  MovieCastModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 18.01.2023.
//

import Foundation

struct MovieCastListModel: Codable {
    let id: Int
    let cast, crew: [CastModel]
}

struct CastModel: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: DepartmentType
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: DepartmentType?
    let job: String?
    
    var profileImageUrl: String {
        return ApiConstant.baseImageUrl + (self.profilePath ?? "")
    }

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

enum DepartmentType: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}
