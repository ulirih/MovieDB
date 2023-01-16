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
    var nowPlaying: PublishSubject<[PlayNowModel]> { get }
    var trendings: PublishSubject<[TrendingModel]> { get }
    
    func fetchData() -> Void
    func didTapMovie(movieId: Int) -> Void
}

class MainViewModel: MainViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let service: ServiceProtocol
    private weak var coordinator: CoordinatorProtocol?
    
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var nowPlaying: PublishSubject<[PlayNowModel]> = PublishSubject()
    var trendings: PublishSubject<[TrendingModel]> = PublishSubject()
    
    init(service: ServiceProtocol, coordinator: CoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchData() {
        isLoading.onNext(true)

        service.fetchNowPlaying()
            .subscribe { movies in
                self.nowPlaying.onNext(movies.results)
            } onFailure: { error in
                self.nowPlaying.onNext([])
            }.disposed(by: disposeBag)
        
        service.fetchTrending(page: 1)
            .subscribe { listModel in
                self.isLoading.onNext(false)
                self.trendings.onNext(listModel.results)
            } onFailure: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func didTapMovie(movieId: Int) {
        coordinator?.goToDetails(for: movieId)
    }
}
