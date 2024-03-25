//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Data Source
    private typealias DataSource = UITableViewDiffableDataSource<UpcomingViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<UpcomingViewModel.Sections, Movie>
    
    //MARK: - Attributes
    private var tableView: UITableView?
    private let searchVM = SearchViewModel()
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await searchVM.onLoad()
            self.updateSnapshot()
        }
    }
}


//MARK: - Actions
extension SearchViewController {
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.upcoming])
        snapshot.appendItems(searchVM.movies, toSection: .upcoming)
        dataSource?.apply(snapshot)
    }
    
    private func navigateToDetailView(with movie: Movie) {
        let detailView = DetailView()
        detailView.configure(with: movie)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}


//MARK: - Setups
private extension SearchViewController {
    func setup() {
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        configureDataSource()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        
        searchController.searchBar.placeholder = "Search for a movie"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        tableView = UITableView()
        guard let tableView = tableView else { return }
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
        guard let tableView = tableView else { return }
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
            cell.configure(with: movie)
            return cell
        }
    }
}


//MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = searchVM.movies[indexPath.row]
        navigateToDetailView(with: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}


//MARK: - Search Result Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
        resultController.delegate = self
        
        Task {
            await searchVM.searchMovies(with: query)
            resultController.update(with: searchVM.movies)
        }
    }
}


extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTap(movie: Movie) {
        navigateToDetailView(with: movie)
    }
}
