//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 02/03/24.
//

import UIKit
import WebKit


class TitlePreviewViewController: UIViewController {
    private var movie: Movie?
    let downloadVM = DownloadViewModel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.configuration.preferences.isElementFullscreenEnabled = true
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        configureConstraints()
    }
    
    @objc
    private func downloadButtonTapped(sender: UIButton) {
        guard let movie = movie else { return }

        Task {
            await downloadVM.saveMovie(with: movie)
            print("movie saved")
        }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//MARK: - Actions
extension TitlePreviewViewController {
    func configure(with movie: Movie, youtubeID: String) {
        self.movie = movie

        titleLabel.text = movie.originalName ?? movie.originalTitle
        overviewLabel.text = movie.overview
        guard let url = URL(string: "https://www.youtube.com/watch?v=" + youtubeID) else { return }
        webView.load(URLRequest(url: url))
    }
    
}
