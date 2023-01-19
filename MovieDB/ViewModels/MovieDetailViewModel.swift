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
    var casts: PublishSubject<[CastModel]> { get }
    
    func fetchDetail() -> Void
    func fetchCasts() -> Void
    func didTapPerson(person: CastModel) -> Void
}

class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private var disposeBag = DisposeBag()
    private var service: ServiceProtocol
    private var coordinator: CoordinatorProtocol
    private var movieId: Int

    var isLoading: PublishSubject<Bool> = PublishSubject()
    var detail: PublishSubject<MovieDetailModel> = PublishSubject()
    var casts: PublishSubject<[CastModel]> = PublishSubject()
    
    init(movieId: Int, service: ServiceProtocol, coordinator: CoordinatorProtocol) {
        self.service = service
        self.coordinator = coordinator
        self.movieId = movieId
    }
    
    func fetchDetail() {
        isLoading.onNext(true)
        service.fetchMovieDetail(movieId: movieId)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] movie in
                self?.isLoading.onNext(false)
                self?.detail.onNext(movie)
            } onFailure: { [weak self] error in
                self?.isLoading.onNext(false)
                self?.detail.onError(error)
            }.disposed(by: disposeBag)
    }
    
    func fetchCasts() {
        service.fetchMovieCast(movieId: movieId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] list in
                let cast = list.cast.filter { $0.knownForDepartment == .acting }.prefix(12)
                self?.casts.onNext(Array(cast))
            }).disposed(by: disposeBag)
    }
    
    func didTapPerson(person: CastModel) {
        coordinator.goToPerson(for: person.id)
    }
}
