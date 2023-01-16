//
//  MovieListModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation

struct PlayNowListModel: Codable {
    let page: Int
    let results: [PlayNowModel]
    let totalResults, totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
