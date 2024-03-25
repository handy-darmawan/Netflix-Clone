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
    private var tableView = UITableView()
    private let upcomingVM = UpcomingViewModel()
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureDataSource()
        Task {
            await upcomingVM.onLoad()
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
    }
}


//MARK: - Actions
extension UpcomingViewController {
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.upcoming])
        snapshot.appendItems(upcomingVM.movies, toSection: .upcoming)
        dataSource?.apply(snapshot)
    }
    
    private func navigateToDetailView(with movie: Movie) {
        let detailView = DetailView()
        detailView.setMovie(with: movie)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}


//MARK: - Setups
private extension UpcomingViewController {
    func setup() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Upcoming"
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
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
        navigateToDetailView(with: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
