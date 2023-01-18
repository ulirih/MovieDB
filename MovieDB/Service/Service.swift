//
//  Service.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 23.12.2022.
//

import Foundation
import RxSwift

class Service: ServiceProtocol {
    
    func fetchMovieDetail(movieId: Int) -> Single<MovieDetailModel> {
        let urlString = "\(ApiConstant.baseUrl)/movie/\(movieId)?api_key=\(ApiConstant.apiKey)"
        return baseRequest(for: urlString)
    }
    
    
    func fetchNowPlaying() -> Single<PlayNowListModel> {
        let urlString = "\(ApiConstant.baseUrl)/movie/now_playing?api_key=\(ApiConstant.apiKey)"
        return baseRequest(for: urlString)
    }
    
    func fetchTrending(page: Int) -> Single<TrendingListModel> {
        let urlString = "\(ApiConstant.baseUrl)/trending/all/day?api_key=\(ApiConstant.apiKey)&page=\(String(describing: page))"
        return baseRequest(for: urlString)
    }
    
    func fetchMovieCast(movieId: Int) -> Single<MovieCastListModel> {
        let urlString = "\(ApiConstant.baseUrl)/movie/\(movieId)/credits?api_key=\(ApiConstant.apiKey)"
        return baseRequest(for: urlString)
    }
    
    private func baseRequest<T: Decodable>(for urlString: String) -> Single<T> {
        return Single<T>.create { observer in
            guard let url = URL(string: urlString) else {
                observer(.failure(NetworkErrorType.incorrectUrlError))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, responce, error in
                
                guard let data = data, error == nil else {
                    observer(.failure(NetworkErrorType.serviceError))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(result))
                } catch let error {
                    print(error.localizedDescription)
                    print(urlString)
                    observer(.failure(NetworkErrorType.parseError))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
