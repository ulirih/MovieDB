//
//  CoordinatorProtocol.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 12.01.2023.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
    func goToMain()
    func goToDetails(for movieId: Int)
    func goToPerson(for personId: Int)
}
