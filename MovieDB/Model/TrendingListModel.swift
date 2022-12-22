//
//  TradingListModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation

struct TrendingListModel: Codable {
    let page: Int
    let results: [TrendingModel]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
