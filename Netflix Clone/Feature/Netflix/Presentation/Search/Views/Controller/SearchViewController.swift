//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class SearchViewController: UIViewController {
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
        navigationItem.title = "Search"
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
        
//        NetworkManager.shared.getDiscoverMovies { [weak self] result in
//            switch result {
//            case .success(let movies):
//                self?.data = movies
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a movie"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
        
//        NetworkManager.shared.getMovieDetail(with: movieTitle) { [ weak self ] results in
//            guard let self = self else { return }
//            switch results {
//            case .success(let movieDetail):
//                DispatchQueue.main.async {
//                    let vc = TitlePreviewViewController()
//                    let vm = TitlePreviewViewModel(title: movieTitle, youtubeView: movieDetail, titleOverview: movieOverview)
//                    vc.configure(with: vm, movie: movie)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
//        resultController.delegate = self
        
//        NetworkManager.shared.search(with: query) { result in
//            switch result {
//            case .success(let movies):
//                resultController.update(with: movies)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}

//extension SearchViewController: SearchResultsViewControllerDelegate {
//    func didTap(vm: TitlePreviewViewModel, movie: Movie) {
//        //push to the next view controller
//        DispatchQueue.main.async { [ weak self] in
//            guard let self = self else { return }
//            let vc = TitlePreviewViewController()
//            vc.configure(with: vm, movie: movie)
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}

