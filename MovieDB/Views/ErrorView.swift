//
//  ErrorView.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 18.01.2023.
//

import UIKit

class ErrorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(center: CGPoint) {
        super.init(frame: .zero)
        self.center = center
        setup()
    }
    
    private func setup() {
        addSubview(image)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70),
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 14),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getNunitoFont(type: .bold)
        label.textColor = .label
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
