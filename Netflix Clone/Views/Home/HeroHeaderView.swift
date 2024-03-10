//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by ndyyy on 27/02/24.
//

import UIKit

class HeroHeaderView: UIView {

    private var imageView: UIImageView!
    private var playButton: UIButton!
    private var downloadButton: UIButton!
    private var movie: Movie?
    var playButtonDidTapped: ((TitlePreviewViewModel) -> Void)?

    init(frame: CGRect, playButtonDidTapped: @escaping (TitlePreviewViewModel) -> Void) {
        self.playButtonDidTapped = playButtonDidTapped
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupImageView()
        setupGradient()
        setupPlayButton()
        setupDownloadButton()
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        layer.addSublayer(gradient)
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mock-underthedome")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func printers(_ sender: UIButton) {
        guard 
            let buttonLabel = sender.titleLabel?.text,
            let movie = movie,
            let title = movie.originalTitle ?? movie.originalName,
            let titleOverview = movie.overview
        else { return }
        
        if buttonLabel == "Play" {
            APIManager.shared.getMovieDetail(with: title + " trailer") { results in
                switch results {
                case .success(let results):
                    let vm = TitlePreviewViewModel(title: title, youtubeView: results, titleOverview: titleOverview)
                    
                    guard let playButtonDidTapped = self.playButtonDidTapped else { return }
                    playButtonDidTapped(vm)
                case .failure(let error):
                    print(error)
                }
            }
        } else if buttonLabel == "Download" {
            CoreDataDataSource.shared.save(movie: movie) { results in
                switch results {
                case .success:
                    print("Movie saved")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupPlayButton() {
        playButton = UIButton(frame: .zero)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(printers), for: .touchUpInside)
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
    
    private func setupDownloadButton() {
        downloadButton = UIButton(frame: .zero)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.addTarget(self, action: #selector(printers), for: .touchUpInside)
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
    
    func configure(with movie: Movie) {
        self.movie = movie
        guard
            let imagePath = movie.posterPath,
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath))")
        else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
}
