//
//  ServiceProtocol.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 22.12.2022.
//

import Foundation
import RxSwift

protocol ServiceProtocol: AnyObject {
    func fetchNowPlaying() -> Single<MovieListModel>
    func fetchTrending(page: Int) -> Single<TrendingListModel>
    func fetchMovieDetail(movieId: Int) -> Single<String>
}

enum NetworkErrorType: Error {
    case incorrectUrlError
    case parseError
    case serviceError
}

struct ApiConstant {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "70c8ec72951fd44fa58418ed870fb477"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w500/"
}
