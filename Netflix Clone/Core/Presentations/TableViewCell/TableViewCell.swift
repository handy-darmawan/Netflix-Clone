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
    
    //MARK: - Properties
    private var containerView = UIView()
    private var movieImageView = UIImageView()
    private var movieLabel = UILabel()
    private var playTitleButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Action
extension TableViewCell {
    func configure(for movie: Movie) {
        setup()
        guard let title = movie.originalName ?? movie.originalTitle else { return }
        
        movieLabel.text = title
        let imageURL = imageURL(from: movie)
        movieImageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    private func imageURL(from movie: Movie) -> URL? {
        guard
            let imagePath = movie.posterPath,
            let url = URL(string: "\(MovieNetworkManager.shared.imageBaseURL)\(imagePath)")
        else { return nil}
        return url
    }
}


//MARK: - Setup
private extension TableViewCell {
    func setup() {
        setupContainer()
        setupImageView()
        setupButton()
        setupLabel()
    }
    
    func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    func setupImageView() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.clipsToBounds = true
        containerView.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupButton() {
        playTitleButton.translatesAutoresizingMaskIntoConstraints = false
        let playImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        playTitleButton.setImage(playImage, for: .normal)
        containerView.addSubview(playTitleButton)
        
        NSLayoutConstraint.activate([
            playTitleButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            playTitleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            playTitleButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playTitleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func setupLabel() {
        movieLabel.translatesAutoresizingMaskIntoConstraints = false
        movieLabel.numberOfLines = 0
        containerView.addSubview(movieLabel)
        
        NSLayoutConstraint.activate([
            movieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 30),
            movieLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor),
            movieLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            movieLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
