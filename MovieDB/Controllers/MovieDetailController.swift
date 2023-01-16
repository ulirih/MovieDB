//
//  MovieDetailController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 12.01.2023.
//

import UIKit
import RxSwift

class MovieDetailController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Details"
        
        let service = Service()
        service.fetchMovieDetail(movieId: movieId!)
            .subscribe { value in
                print(value)
            } onFailure: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }

}
