//
//  HeaderCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 10.01.2023.
//

import Foundation
import UIKit

class HeaderViewCell: UICollectionReusableView {
    static let reusableId = "HeaderCell"
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstrains()
    }
    
    private func setupView() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .label.withAlphaComponent(0.7)
        textLabel.numberOfLines = 1
        textLabel.font = UIFont.getNunitoFont(type: .light, size: 14)
        addSubview(textLabel)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
