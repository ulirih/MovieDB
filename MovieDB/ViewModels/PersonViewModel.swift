//
//  PersonViewModel.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 19.01.2023.
//

import Foundation
import RxSwift

protocol PersonViewModelProtocol: AnyObject {
    var isLoading: PublishSubject<Bool> { get }
    var person: PublishSubject<PersonModel> { get }
    
    func fetchPerson() -> Void
}

class PersonViewModel: PersonViewModelProtocol {
    private let disposeBag = DisposeBag()
    private var service: ServiceProtocol
    private var personId: Int
    
    var isLoading: PublishSubject<Bool> = PublishSubject()
    var person: PublishSubject<PersonModel> = PublishSubject()
    
    init(personId: Int, service: ServiceProtocol) {
        self.personId = personId
        self.service = service
    }
    
    func fetchPerson() {
        isLoading.onNext(true)
        service.fetchPerson(personId: personId)
            .observe(on: MainScheduler.instance)
            .subscribe { person in
                self.isLoading.onNext(false)
                self.person.onNext(person)
            } onFailure: { error in
                self.isLoading.onNext(false)
                self.person.onError(error)
            }.disposed(by: disposeBag)
    }
}
