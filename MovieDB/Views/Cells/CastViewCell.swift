//
//  CastViewCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 18.01.2023.
//

import UIKit

class CastViewCell: UICollectionViewCell {
    static let reusableId = "CastViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func configure(model: CastModel) {
        nameLabel.text = model.name
        personImage.sd_setImage(with: URL(string: model.profileImageUrl), completed: nil)
        layoutIfNeeded()
    }
    
    private func setupViews() {
        addSubview(personImage)
        addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 150),
            widthAnchor.constraint(equalToConstant: 100),
            
            personImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            personImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            personImage.heightAnchor.constraint(equalToConstant: CGFloat(80)),
            personImage.widthAnchor.constraint(equalToConstant: CGFloat(80)),

            nameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: personImage.centerXAnchor),
        ])
    }
    
    private let personImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = CGFloat(40)
        image.clipsToBounds = true
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.getNunitoFont(type: .regular, size: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
