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
    
    private var movieImageView: UIImageView?
    private var playButton: UIButton?
    private var downloadButton: UIButton?
    private var movie: Movie?
    //we need callback here to handle button
    
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
            let movie = movie,
            let title = movie.originalTitle ?? movie.originalName,
            let titleOverview = movie.overview
        else { return }
        
        if buttonLabel == "Play" {
            print("Play button tapped \(title)")
            //            NetworkManager.shared.getMovieDetail(with: title + " trailer") { results in
            //                switch results {
            //                case .success(let results):
            //                    let vm = TitlePreviewViewModel(title: title, youtubeView: results, titleOverview: titleOverview)
            //
            //                    guard let playButtonDidTapped = self.playButtonDidTapped else { return }
            //                    playButtonDidTapped(vm)
            //                case .failure(let error):
            //                    print(error)
            //                }
            //            }
        } else if buttonLabel == "Download" {
            print("Download button tapped \(title)")
            //            CoreDataDataSource.shared.save(movie: movie) { results in
            //                switch results {
            //                case .success:
            //                    print("Movie saved")
            //                case .failure(let error):
            //                    print(error)
            //                }
            //            }
            //        }
        }
    }
    
    func setImage(with movie: Movie) {
        self.movie = movie
        guard
            let imagePath = movie.posterPath,
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath))"),
            let movieImageView = movieImageView
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
        movieImageView = UIImageView(frame: .zero)
        guard let movieImageView = movieImageView else { return }
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
        playButton = UIButton(frame: .zero)
        guard let playButton = playButton else { return }
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play", for: .normal)
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
        downloadButton = UIButton(frame: .zero)
        guard let downloadButton = downloadButton else { return }
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle("Download", for: .normal)
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
