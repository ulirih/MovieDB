//
//  MarkView.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 30.12.2022.
//

import UIKit

class MarkView: UIView {
    
    var text: UILabel = UILabel()
    var value: Double = 0 {
        didSet {
            setValue()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        text.textColor = .black
        text.font = UIFont.getNunitoFont(type: .bold, size: 14)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        addSubview(text)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 25),
            widthAnchor.constraint(equalToConstant: 55),
            text.centerXAnchor.constraint(equalTo: centerXAnchor),
            text.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setValue() {
        text.text = numberFormatter.string(from: NSNumber(value: value))
        backgroundColor = self.viewBgColor
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.decimalSeparator = "."
        
        return formatter
    }()
    
    private var viewBgColor: UIColor {
        get {
            switch value {
            case 0..<5:
                return .systemRed
            case 5..<7:
                return .systemYellow
            case 7...10:
                return .systemGreen
            default: return .white
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
