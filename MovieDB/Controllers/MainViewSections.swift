//
//  MainViewSections.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 28.12.2022.
//

import Foundation

enum MainViewSections: Int, Hashable {
    case playingNow
    case trendings
    
    var title: String {
        switch self {
        case .trendings:
            return "Today Trendings"
        case .playingNow:
            return "Playing now"
        }
    }
}
