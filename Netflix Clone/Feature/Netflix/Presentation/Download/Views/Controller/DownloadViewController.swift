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
    
    //MARK: - Attributes
    private var tableView = UITableView()
    private let downloadVM = DownloadViewModel()
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await downloadVM.onLoad()
            self.updateSnapshot()
        }
    }
}


//MARK: - Actions
extension DownloadViewController {
    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.download])
        snapshot.appendItems(downloadVM.movies, toSection: .download)
        dataSource?.apply(snapshot)
    }
    
    private func navigateToDetailView(with movie: Movie) {
        let detailView = DetailView()
        detailView.configure(with: movie)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}


//MARK: - Setups
private extension DownloadViewController {
    func setup() {
        setupNavigationBar()
        setupTableView()
        configureDataSource()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Download"
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
extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
