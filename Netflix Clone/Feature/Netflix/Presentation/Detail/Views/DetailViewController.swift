//
//  DetailViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 02/03/24.
//

import UIKit
import WebKit


class DetailViewController: UIViewController {
    //MARK: - Attributes
    private var titleLabel = UILabel()
    private var scrollView = UIScrollView()
    private var webView: WKWebView?
    private var overviewLabel = UILabel()
    private var downloadButton = UIButton()
    private let containerView = UIView()
    
    private var movie: Movie?
    private let detailVM = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        configure(with: movie)
    }
    
    deinit {
        movie = nil
        webView = nil
    }
}


//MARK: - Action
extension DetailViewController {
    func setMovie(with movie: Movie) {
        self.movie = movie
    }
    
    private func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        titleLabel.text = movie.originalName ?? movie.originalTitle
        overviewLabel.text = movie.overview
        configureWebView(with: movie)
    }
    
    private func configureWebView(with movie: Movie) {
        Task {
            let youtubeID = await detailVM.getYoutubeID(for: movie) ?? "Unknown"
            guard let url = URL(string: "https://www.youtube.com/watch?v=" + youtubeID) else { return }
            webView?.load(URLRequest(url: url))
        }
    }
    
    @objc
    private func downloadButtonTapped(sender: UIButton) {
        guard let movie = movie else { return }
        Task { await detailVM.saveMovie(with: movie) }
    }
}


//MARK: - Setup
private extension DetailViewController {
    func setup() {
        setupScrollView()
        setupContainer()
        setupWebView()
        setupTitleLabel()
        setupOverviewLabel()
        setupDownloadButton()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func setupWebView() {
        webView = WKWebView()
        guard let webView = webView else { return }
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.isElementFullscreenEnabled = true
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        containerView.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4),
        ])
    }
    
    func setupTitleLabel() {
        guard let webView = webView else { return }
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
        containerView.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}
