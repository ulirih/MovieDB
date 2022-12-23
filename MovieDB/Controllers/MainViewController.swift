//
//  ViewController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieDB"
        view.backgroundColor = .systemBackground
        
        viewModel = MainViewModel(service: Service())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
}

