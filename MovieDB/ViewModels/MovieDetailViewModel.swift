//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 17.01.2023.
//

import Foundation
import RxSwift

protocol MovieDetailViewModelProtocol: AnyObject {
    var isLoading: PublishSubject<Bool> { get }
    var detail: PublishSubject<MovieDetailModel> { get }
    
    func fetchDetail(id: Int) -> Void
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private var disposeBag = DisposeBag()
    private var service: ServiceProtocol
    private var coordinator: CoordinatorProtocol
    
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var detail: PublishSubject<MovieDetailModel> = PublishSubject()
    
    init(service: ServiceProtocol, coordinator: CoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func fetchDetail(id: Int) {
        isLoading.onNext(true)
        service.fetchMovieDetail(movieId: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] movie in
                self?.isLoading.onNext(false)
                self?.detail.onNext(movie)
            } onFailure: { [weak self] error in
                self?.isLoading.onNext(false)
                self?.detail.onError(error)
            }.disposed(by: disposeBag)
    }
    
    
}
