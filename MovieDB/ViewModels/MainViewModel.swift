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
    var isEnableLoadMore: Bool { get }
    var nowPlaying: PublishSubject<[PlayNowModel]> { get }
    var trendings: PublishSubject<[TrendingModel]> { get }
    
    func fetchNowPlaying() -> Void
    func fetchTrendings() -> Void
    func didTapMovie(movieId: Int) -> Void
}

class MainViewModel: MainViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let service: ServiceProtocol
    private weak var coordinator: CoordinatorProtocol?
    
    private var currentPage: Int = 0
    
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var isEnableLoadMore: Bool = false
    var nowPlaying: PublishSubject<[PlayNowModel]> = PublishSubject()
    var trendings: PublishSubject<[TrendingModel]> = PublishSubject()
    
    init(service: ServiceProtocol, coordinator: CoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchNowPlaying() {
        service.fetchNowPlaying()
            .subscribe { movies in
                self.nowPlaying.onNext(movies.results)
            } onFailure: { error in
                self.nowPlaying.onNext([])
            }.disposed(by: disposeBag)
    }
    
    func fetchTrendings() {
        isLoading.onNext(true)
        currentPage += 1
        service.fetchTrending(page: currentPage)
            .subscribe { listModel in
                self.isEnableLoadMore = listModel.totalPages > self.currentPage
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
