//
//  Service.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 23.12.2022.
//

import Foundation

class Service: ServiceProtocol {
    private let apiKey = "70c8ec72951fd44fa58418ed870fb477"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func fetchNowPlaying(completion: @escaping (Result<MovieListModel, NetworkErrorType>) -> Void) {
        let urlString = "\(baseUrl)/movie/now_playing?api_key=\(apiKey)"
        
        baseRequest(for: urlString) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    func fetchTrending(page: Int, completion: @escaping (Result<TrendingListModel, NetworkErrorType>) -> Void) {
        let urlString = "\(baseUrl)/trending/all/day?api_key=\(apiKey)&page=\(String(describing: page))"
        
        baseRequest(for: urlString) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
    
    private func baseRequest<T: Decodable>(for urlString: String, completion: @escaping (Result<T, NetworkErrorType>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.incorrectUrlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.serviceError))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.parseError))
            }
            
        }.resume()
    }
}