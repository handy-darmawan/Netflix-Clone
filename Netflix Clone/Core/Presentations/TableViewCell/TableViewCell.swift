//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by ndyyy on 29/02/24.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    //MARK: - Attributes
    private var upcomingImageView = UIImageView()
    private var upcomingLabel = UILabel()
    private var playTitleButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setups()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: Actions
extension TableViewCell {
    func configure(with movie: Movie) {
        guard
            let posterPath = movie.posterPath,
            let title = movie.originalName ?? movie.originalTitle
        else { return }
        
        upcomingLabel.text = title
        let path = "https://image.tmdb.org/t/p/w500\(posterPath)"
        upcomingImageView.sd_setImage(with: URL(string: path), completed: nil)
    }
}


//MARK: Setups
private extension TableViewCell {
    func setups() {
        setupImageView()
        setupButton()
        setupLabel()
    }
    
    func setupImageView() {
        upcomingImageView.translatesAutoresizingMaskIntoConstraints = false
        upcomingImageView.clipsToBounds = true
        contentView.addSubview(upcomingImageView)
        
        NSLayoutConstraint.activate([
            upcomingImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upcomingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            upcomingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            upcomingImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupButton() {
        playTitleButton.translatesAutoresizingMaskIntoConstraints = false
        let playImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        playTitleButton.setImage(playImage, for: .normal)
        contentView.addSubview(playTitleButton)
        
        NSLayoutConstraint.activate([
            playTitleButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            playTitleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func setupLabel() {
        upcomingLabel.translatesAutoresizingMaskIntoConstraints = false
        upcomingLabel.numberOfLines = 0
        contentView.addSubview(upcomingLabel)
        
        NSLayoutConstraint.activate([
            upcomingLabel.leadingAnchor.constraint(equalTo: upcomingImageView.trailingAnchor, constant: 30),
            upcomingLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -15),
            upcomingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
