//
//  MainViewModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 23.12.2022.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func fetchData() -> Void
}

class MainViewModel: MainViewModelProtocol {
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        service.fetchNowPlaying { result in
            print(Thread.isMainThread)
            switch result {
            case .success(let movies):
                print(movies.results.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        service.fetchTrending(page: 1) { result in
            switch result {
            case .success(let movies):
                print(movies.results.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
    }
}
