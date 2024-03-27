//
//  DownloadViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

class DownloadViewController: UIViewController {
    //MARK: - Data Source
    private typealias DataSource = UITableViewDiffableDataSource<DownloadViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DownloadViewModel.Sections, Movie>
    
    //MARK: - Properties
    private var tableView = UITableView()
    private var emptyStateView = UIView()
    private var emptyLabel = UILabel()
    private let downloadVM = DownloadViewModel()
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
            await downloadVM.onLoad()
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
    }
}


//MARK: - Action
private extension DownloadViewController {
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.download])
        snapshot.appendItems(downloadVM.movies, toSection: .download)
        dataSource?.apply(snapshot)
        
        if downloadVM.movies.isEmpty {
            showEmptyState()
        }
        else {
            hideEmptyState()
        }
    }
    
    func navigateToDetailView(with movie: Movie) {
        let detailView = DetailViewController()
        detailView.setMovie(with: movie)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func showEmptyState() {
        emptyStateView.isHidden = false
        emptyLabel.isHidden = false
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
        emptyLabel.isHidden = true
    }
}

extension DownloadViewController: ViewInteraction {}


//MARK: - Setup
private extension DownloadViewController {
    func setup() {
        setupNavigationBar()
        setupTableView()
        setupEmptyState()
    }
    
    func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.backgroundColor = .systemBackground
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No movies downloaded yet!"
        emptyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        emptyLabel.textColor = .label
        emptyStateView.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Download"
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.separatorColor = .clear
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
extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        disableViewInteraction()
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = downloadVM.movies[indexPath.row]
        navigateToDetailView(with: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            let movie = self.downloadVM.movies[indexPath.row]
            Task {
                await self.downloadVM.deleteMovie(with: movie)
                self.downloadVM.movies.remove(at: indexPath.row)
                self.updateSnapshot()
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
