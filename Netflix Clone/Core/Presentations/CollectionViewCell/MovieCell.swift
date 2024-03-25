//
//  MovieCell.swift
//  Netflix Clone
//
//  Created by ndyyy on 17/03/24.
//

import UIKit
import SDWebImage


class MovieCell: UICollectionViewCell {
    static let identifier = "CellItem"
    
    //MARK: Attributes
    private var movieImageView = UIImageView()
    private var playButton = UIButton()
    private var downloadButton = UIButton()
    private var movie: Movie?
    
    //MARK: Delegate
    weak var delegate: DetailViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///configure for header or just cell
    func configureFor(type: CellType, movie: Movie) {
        setup(for: type)
        self.movie = movie
        setImage(with: movie)
    }
}


//MARK: Actions
private extension MovieCell {
    @objc func buttonTapped(_ sender: UIButton) {
        guard
            let buttonLabel = sender.titleLabel?.text,
            let buttonType = ButtonType(rawValue: buttonLabel),
            let movie = movie
        else {
            return
            //show action
        }
        
        delegate?.itemTapped(for: buttonType, with: movie)
    }
    
    func setImage(with movie: Movie) {
        self.movie = movie
        guard
            let imagePath = movie.posterPath,
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath))")
        else { return }
        movieImageView.sd_setImage(with: url, completed: nil)
    }
}


//MARK: Setups
private extension MovieCell {
    func setup(for type: CellType) {
        if type == .header {
            setupMovieImageView()
            setupGradient()
            setupPlayButton()
            setupDownloadButton()
        }
        else {
            setupMovieImageView()
        }
    }
    
    func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        layer.addSublayer(gradient)
    }
    
    func setupMovieImageView() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.clipsToBounds = true
        movieImageView.contentMode = .scaleAspectFill
        addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle(ButtonType.play.rawValue, for: .normal)
        playButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.cornerRadius = 5
        addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupDownloadButton() {
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle(ButtonType.download.rawValue, for: .normal)
        downloadButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.cornerRadius = 5
        addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
