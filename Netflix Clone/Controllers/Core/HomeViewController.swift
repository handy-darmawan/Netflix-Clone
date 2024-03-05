//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

/**
 Update:
 1. HomeViewController -> Use Composional layout to make the layout and fill the data with NSDiffableDataSource
 2. HeroHeaderView -> Use UIStackView to make autolayout in button
 3. APIManager -> Too much boiler plate code to fetch and parsing API
            -> Fix the structure of API Manager
 */

enum Sections: CaseIterable {
    case trendingMovies
    case popular
    case trendingTV
    case upcomingMovies
    case topRated
    
    var rawValue: String {
        switch self {
        case .trendingMovies:
            return "Trending Movies"
        case .popular:
            return "Popular"
        case .trendingTV:
            return "Trending TV"
        case .upcomingMovies:
            return "Upcoming Movies"
        case .topRated:
            return "Top Rated"
        }
    }
    
    var value: Int {
        switch self {
        case .trendingMovies:
            return 0
        case .popular:
            return 1
        case .trendingTV:
            return 2
        case .upcomingMovies:
            return 3
        case .topRated:
            return 4
        }
    }
}


class HomeViewController: UIViewController {
    var randomMovie: Movie?
    var heroHeaderView: HeroHeaderView?
    
    
    private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 450))
        tableView.tableHeaderView = heroHeaderView
        
        configureNavbar()
        setHeroHeaderView()
    }
    
    func setHeroHeaderView() {
        APIManager.shared.getTrendingMovies { [weak self] results in
            guard let self = self else { return }
            switch results {
            case .success(let movies):
                let movie = movies.randomElement()
                randomMovie = movie
                if let moviePoster = movie?.posterPath {
                    heroHeaderView?.configure(with: moviePoster)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureNavbar() {
        let netflixLogo = UIImage(named: "netflix48")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil)
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        let playButton = UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [profileButton, playButton]
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.reuseIdentifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.popular.value:
            APIManager.shared.getPopular { result in
                switch result {
                case .success(let response):
                    cell.configure(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.trendingMovies.value:
            APIManager.shared.getTrendingMovies { result in
                switch result {
                case .success(let response):
                    cell.configure(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.trendingTV.value:
            APIManager.shared.getTrendingTv { result in
                switch result {
                case .success(let response):
                    cell.configure(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.upcomingMovies.value:
            APIManager.shared.getUpcomingMovie { result in
                switch result {
                case .success(let response):
                    cell.configure(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.topRated.value:
            APIManager.shared.getTopRated { result in
                switch result {
                case .success(let response):
                    cell.configure(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    //hide the nav bar when scrolling to bottom direction
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Sections.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = Sections.allCases[section].rawValue
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.textColor = .white
    }
}


extension HomeViewController: CollectionItemDelegate {
    func cellDidTapped(_ cell: CollectionViewTableViewCell, vm: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self]  in
            guard let self = self else { return }
            
            let vc = TitlePreviewViewController()
            vc.configure(with: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
