//
//  ServiceProtocol.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func fetchNowPlaying(completion: @escaping (Result<MovieListModel, NetworkErrorType>) -> Void)
    func fetchTrending(page: Int, completion: @escaping (Result<TrendingListModel, NetworkErrorType>) -> Void)
}

enum NetworkErrorType: Error {
    case incorrectUrlError
    case parseError
    case serviceError
}
