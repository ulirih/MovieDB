//
//  MainViewModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 23.12.2022.
//

import Foundation
import RxSwift

protocol MainViewModelProtocol: AnyObject {
    var isLoading: PublishSubject<Bool> { get }
    var nowPlaying: PublishSubject<[MovieModel]> { get }
    var trendings: PublishSubject<[TrendingModel]> { get }
    
    func fetchData() -> Void
    func didTapMovie(movieId: Int) -> Void
}

class MainViewModel: MainViewModelProtocol {
    private let service: ServiceProtocol
    private weak var coordinator: CoordinatorProtocol?
    
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var nowPlaying: PublishSubject<[MovieModel]> = PublishSubject()
    var trendings: PublishSubject<[TrendingModel]> = PublishSubject()
    
    init(service: ServiceProtocol, coordinator: CoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchData() {
        isLoading.onNext(true)
        
        let group = DispatchGroup()
        group.enter()
        service.fetchNowPlaying { [weak self] result in
            switch result {
            case .success(let movies):
                self?.nowPlaying.onNext(movies.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        service.fetchTrending(page: 1) { [weak self] result in
            switch result {
            case .success(let trendings):
                self?.isLoading.onNext(false)
                self?.trendings.onNext(trendings.results)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
    }
    
    func didTapMovie(movieId: Int) {
        coordinator?.goToDetails(for: movieId)
    }
}
