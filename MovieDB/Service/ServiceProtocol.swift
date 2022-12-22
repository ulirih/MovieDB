//
//  ServiceProtocol.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func fetchNowPlaying(page: Int, completion: (Result<MovieListModel, Error>) -> Void)
    func fetchTrending(page: Int, completion: (Result<TrendingListModel, Error>) -> Void)
}
