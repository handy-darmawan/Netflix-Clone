//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //MARK: - Data Source
    private typealias DataSource = UITableViewDiffableDataSource<UpcomingViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<UpcomingViewModel.Sections, Movie>
    
    //MARK: - Attributes
    private var tableView: UITableView?
    private let upcomingVM = UpcomingViewModel()
    
    private var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await upcomingVM.onLoad()
            self.updateSnapshot()
        }
    }
}


//MARK: - Actions
extension UpcomingViewController {
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.upcoming])
        snapshot.appendItems(upcomingVM.movies, toSection: .upcoming)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func navigateToDetailView(with movie: Movie, youtubeID: String) {
        Task {
            let detailView = TitlePreviewViewController()
            detailView.configure(with: movie, youtubeID: youtubeID)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(detailView, animated: true)
            }
        }
    }
}


//MARK: - Setups
private extension UpcomingViewController {
    func setup() {
        setupNavigationBar()
        setupTableView()
        configureDataSource()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Upcoming"
    }
    
    func setupTableView() {
        tableView = UITableView()
        guard let tableView = tableView else { return }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        guard let tableView = tableView else { return }
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            cell.configure(with: movie)
            return cell
        }
    }
}


//MARK: - Delegate
extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = upcomingVM.movies[indexPath.row]
        
        Task {
            let movieYoutube = await upcomingVM.getMovieDetail(for: movie)
            guard let movieYoutube = movieYoutube else { return }
            navigateToDetailView(with: movie, youtubeID: movieYoutube.videoId)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
