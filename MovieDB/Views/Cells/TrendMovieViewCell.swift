//
//  TrendMovieViewCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 29.12.2022.
//

import Foundation
import UIKit
import SDWebImage

class TrendMovieViewCell: UICollectionViewCell {
    static let reusableId = "TrendMovieViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        blurView.contentView.addSubview(nameLabel)
        blurView.contentView.addSubview(imageView)
        blurView.contentView.addSubview(dateLabel)
        blurView.contentView.addSubview(markView)
        blurView.contentView.addSubview(overviewLabel)
        
        contentView.addSubview(blurView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 140),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            overviewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -16),
            
            markView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            markView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
    
    func configure(model: TrendingModel) {
        nameLabel.text = model.nameDisplay
        dateLabel.text = model.dateDisplay
        imageView.sd_setImage(with: URL(string: model.posterUrl), completed: nil)
        markView.setValue(value: model.voteAverage)
        overviewLabel.text = model.overview
    }
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .label
        name.numberOfLines = 2
        name.font = UIFont.getNunitoFont(type: .regular, size: 18)
        
        return name
    }()
    
    private let dateLabel: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = .label.withAlphaComponent(0.7)
        date.font = UIFont.getNunitoFont(type: .light, size: 12)
        
        return date
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.getNunitoFont(type: .regular, size: 14)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .lightGray
        
        return image
    }()
    
    private let markView: MarkView = {
        let mark = MarkView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        
        return mark
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
