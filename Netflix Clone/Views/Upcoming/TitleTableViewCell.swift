//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by ndyyy on 29/02/24.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    private var upcomingImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var upcomingLabel: UILabel = {
         let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.numberOfLines = 0
          return label
     }()
    
    private var playTitleButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(s   ystemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(playImage, for: .normal)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(upcomingImageView)
        contentView.addSubview(upcomingLabel)
        contentView.addSubview(playTitleButton)
        
        NSLayoutConstraint.activate([
            upcomingImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upcomingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            upcomingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            upcomingImageView.widthAnchor.constraint(equalToConstant: 100),
            
            upcomingLabel.leadingAnchor.constraint(equalTo: upcomingImageView.trailingAnchor, constant: 30),
//            upcomingLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            upcomingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            upcomingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            playTitleButton.leadingAnchor.constraint(equalTo: upcomingLabel.trailingAnchor, constant: 10),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configure(with model: Movie) {
        let path = "https://image.tmdb.org/t/p/w500\(model.posterPath ?? "")"
        upcomingImageView.sd_setImage(with: URL(string: path), completed: nil)
        upcomingLabel.text = model.originalName ?? model.originalTitle ?? "Unknown"
    }
    
}
