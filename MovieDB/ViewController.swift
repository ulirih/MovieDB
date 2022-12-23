//
//  ViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit

class ViewController: UIViewController {
    private var service: ServiceProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieDB"
        view.backgroundColor = .systemBackground
        service = Service()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        service.fetchNowPlaying { result in
            switch result {
            case .success(let movies):
                print(movies.results.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        service.fetchTrending(page: 1) { result in
            switch result {
            case .success(let movies):
                print(movies.results.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

