//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Data Source
    private typealias DataSource = UITableViewDiffableDataSource<SearchViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Sections, Movie>
    
    //MARK: - Properties
    private var tableView = UITableView()
    private let searchVM = SearchViewModel()
    private var dataSource: DataSource?
    var viewInteraction: UITableView { tableView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableViewInteraction()
        configureDataSource()
        Task {
            await searchVM.onLoad()
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dataSource = nil
    }
}


//MARK: - Action
extension SearchViewController {
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.search])
        snapshot.appendItems(searchVM.movies, toSection: .search)
        dataSource?.apply(snapshot)
    }
    
    private func navigateToDetailView(with movie: Movie) {
        let detailView = DetailViewController()
        detailView.setMovie(with: movie)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension SearchViewController: ViewInteraction {}


//MARK: - Setup
private extension SearchViewController {
    func setup() {
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
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
            cell.configure(for: movie)
            return cell
        }
    }
}


//MARK: - Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        disableViewInteraction()
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = searchVM.movies[indexPath.row]
        navigateToDetailView(with: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

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

extension SearchViewController: DetailViewDelegate {
    func itemTapped(for type: ButtonType, with movie: Movie) {
        if type == .none {
            navigateToDetailView(with: movie)
        }
    }
}
