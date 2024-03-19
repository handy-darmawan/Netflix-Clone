//
//  HeaderView.swift
//  Netflix Clone
//
//  Created by ndyyy on 19/03/24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = "headerView"
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setups()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension HeaderView {
    func configure(with title: String) {
        textLabel.text = title
        textLabel.textColor = .white
        textLabel.textAlignment = .left
    }
}


//MARK: Setup
private extension HeaderView {
    func setups() {
        setupLabelConstraints()
    }
    
    func setupLabelConstraints() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
