//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    var data: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Upcoming"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NetworkManager.shared.getUpcomingMovie { [weak self] result in
            switch result {
            case .success(let movies):
                self?.data = movies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = data[indexPath.row]
        guard 
            let movieTitle = movie.originalTitle ?? movie.originalName,
            let movieOverview = movie.overview
        else { return }
        
        NetworkManager.shared.getMovieDetail(with: movieTitle) { [ weak self ] results in
            guard let self = self else { return }
            switch results {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    
                    let vm = TitlePreviewViewModel(title: movieTitle, youtubeView: movieDetail, titleOverview: movieOverview)
                    vc.configure(with: vm, movie: movie)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
