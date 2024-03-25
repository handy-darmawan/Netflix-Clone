//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 02/03/24.
//

import UIKit
import WebKit


class DetailView: UIViewController {
    
    //MARK: - Attributes
    private var titleLabel: UILabel?
    private var webView: WKWebView?
    private var overviewLabel: UILabel?
    private var downloadButton: UIButton?
    
    private var movie: Movie?
    let downloadVM = DownloadViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setups()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Actions
extension DetailView {
    func configure(with movie: Movie, youtubeID: String) {
        self.movie = movie
        guard
            let titleLabel = titleLabel,
            let overviewLabel = overviewLabel,
            let webView = webView
        else { return }
        
        titleLabel.text = movie.originalName ?? movie.originalTitle
        overviewLabel.text = movie.overview
        guard let url = URL(string: "https://www.youtube.com/watch?v=" + youtubeID) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func configure(with movie: Movie) {
        self.movie = movie
        guard
            let titleLabel = titleLabel,
            let overviewLabel = overviewLabel,
            let webView = webView
        else { return }
        
        titleLabel.text = movie.originalName ?? movie.originalTitle
        overviewLabel.text = movie.overview
        webView.isOpaque = false
        
        //fetch youtubeID
        let getMovieUseCase = GetMovieUseCase(youtubeRepository: YoutubeRepository.shared)
        Task {
            let youtube = try await getMovieUseCase.execute(with: "\(movie.originalName ?? movie.originalTitle) trailer")
            let youtubeID = youtube.videoId
            
            guard let url = URL(string: "https://www.youtube.com/watch?v=" + youtubeID) else { return }
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc
    private func downloadButtonTapped(sender: UIButton) {
        guard let movie = movie else { return }
        
        Task {
            await downloadVM.saveMovie(with: movie)
            print("movie saved")
        }
    }
}


//MARK: - Setups
private extension DetailView {
    func setups() {
        setupWebView()
        setupTitleLabel()
        setupOverviewLabel()
        setupDownloadButton()
    }
    
    func setupWebView() {
        webView = WKWebView(frame: .zero)
        guard let webView = webView else { return }
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.isElementFullscreenEnabled = true
        webView.scrollView.isScrollEnabled = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        ])
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        
        guard
            let titleLabel = titleLabel,
            let webView = webView
        else { return }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupOverviewLabel() {
        overviewLabel = UILabel()
        guard
            let overviewLabel = overviewLabel,
            let titleLabel = titleLabel
        else { return }
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = .systemFont(ofSize: 18, weight: .regular)
        overviewLabel.numberOfLines = 0
        view.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    func setupDownloadButton() {
        downloadButton = UIButton()
        
        guard
            let downloadButton = downloadButton,
            let overviewLabel = overviewLabel
        else { return }
        
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.backgroundColor = .systemBlue
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.layer.cornerRadius = 8
        view.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
