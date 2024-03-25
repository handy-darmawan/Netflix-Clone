//
//  DetailView.swift
//  Netflix Clone
//
//  Created by ndyyy on 02/03/24.
//

import UIKit
import WebKit


class DetailView: UIViewController {
    
    //MARK: - Attributes
    private var titleLabel = UILabel()
    private var webView = WKWebView()
    private var overviewLabel = UILabel()
    private var downloadButton = UIButton()
    private let containerView = UIView()
    
    private var movie: Movie?
    private let detailVM = DetailViewModel()

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
    func configure(with movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.originalName ?? movie.originalTitle
        overviewLabel.text = movie.overview
        configureWebView(with: movie)
    }
    
    private func configureWebView(with movie: Movie) {
        Task {
            //fetch youtubeID
            let youtubeID = await detailVM.getYoutubeID(for: movie) ?? "Unknown"
            guard let url = URL(string: "https://www.youtube.com/watch?v=" + youtubeID) else { return }
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc
    private func downloadButtonTapped(sender: UIButton) {
        guard let movie = movie else { return }
        
        Task {
            await detailVM.saveMovie(with: movie)
            print("movie saved") //show data
        }
    }
}


//MARK: - Setups
private extension DetailView {
    func setups() {
        setupContainer()
        setupWebView()
        setupTitleLabel()
        setupOverviewLabel()
        setupDownloadButton()
    }
    
    func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.isElementFullscreenEnabled = true
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        containerView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func setupOverviewLabel() {
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = .systemFont(ofSize: 18, weight: .regular)
        overviewLabel.numberOfLines = 0
        containerView.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            
        ])
    }
    
    func setupDownloadButton() {
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.backgroundColor = .systemBlue
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.layer.cornerRadius = 8
        view.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
