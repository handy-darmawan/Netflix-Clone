//
//  HeaderView.swift
//  Netflix Clone
//
//  Created by ndyyy on 19/03/24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = "headerView"
    
    private var textLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension HeaderView {
    func configure(with title: String) {
        guard let textLabel = textLabel else { return }
        textLabel.text = title
        textLabel.textColor = .white
        textLabel.textAlignment = .left
    }
}


//MARK: Setup
private extension HeaderView {
    func setup() {
        setupLabelConstraints()
    }
    
    func setupLabelConstraints() {
        textLabel = UILabel()
        
        guard let textLabel = textLabel else { return }
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
