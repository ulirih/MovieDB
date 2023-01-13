//
//  MovieDetailController.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 12.01.2023.
//

import UIKit

class MovieDetailController: UIViewController {
    
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Details"
        
        print(movieId ?? -1)
    }

}
