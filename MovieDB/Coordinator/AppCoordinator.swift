//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 12.01.2023.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToMain()
    }
    
    func goToMain() {
        let viewModel = MainViewModel(service: Service(), coordinator: self)
        let mainVC = MainViewController()
        mainVC.viewModel = viewModel
        
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    func goToDetails(for movieId: Int) {
        let detailVC = MovieDetailController()
        detailVC.movieId = movieId
        navigationController.pushViewController(detailVC, animated: true)
    }
}
