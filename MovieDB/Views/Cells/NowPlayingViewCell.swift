//
//  NowPlayingViewCell.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 10.01.2023.
//

import UIKit
import SDWebImage

class NowPlayingViewCell: UICollectionViewCell {
    static let reusableId = "NowPlayingViewCell"
    let backgroundImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    func configure(with model: PlayNowModel) {
        backgroundImage.sd_setImage(with: URL(string: model.backdropUrl))
        markView.value = model.voteAverage
        nameLabel.text = model.title
    }
    
    private func setupViews() {
        backgroundImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        
        addSubview(backgroundImage)
        
        detailContainer.addSubview(markView)
        detailContainer.addSubview(nameLabel)
        addSubview(detailContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            markView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            markView.centerYAnchor.constraint(equalTo: detailContainer.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: detailContainer.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: markView.trailingAnchor, constant: -8)
        ])
    }
    
    private var detailContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.8)
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .label
        name.numberOfLines = 1
        name.font = UIFont.getNunitoFont(type: .regular)
        
        return name
    }()
    
    private let markView: MarkView = {
        let mark = MarkView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        
        return mark
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
