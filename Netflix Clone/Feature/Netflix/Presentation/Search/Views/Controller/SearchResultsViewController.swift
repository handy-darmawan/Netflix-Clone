//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 29/02/24.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTap(movie: Movie, youtubeID: String)
}

class SearchResultsViewController: UIViewController {
    //MARK: - Data Source
    private typealias DataSource = UICollectionViewDiffableDataSource<SearchViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Sections, Movie>
    
    //MARK: - Attributes
    var searchVM: SearchViewModel = SearchViewModel()
    private var dataSource: DataSource?
    weak var delegate: SearchResultsViewControllerDelegate?
    var movies: [Movie] = []
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSnapshots()
    }
}


//MARK: Actions
extension SearchResultsViewController {
    func updateSnapshots() {
        var snapshot = Snapshot()
        snapshot.appendSections([.search])
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot)
    }
    
    func update(with movies: [Movie]) {
        self.movies = movies
        updateSnapshots()
    }
}


//MARK: Setups
private extension SearchResultsViewController {
    func setups() {
        setupCollectionView()
        setupDataSource()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { return UICollectionViewCell() }
            cell.configureFor(type: .normal, movie: movie)
            return cell
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        
        Task {
            let movieYoutube = await searchVM.getMovieDetail(for: movie)
            guard let movieYoutube = movieYoutube else { return }
            delegate?.didTap(movie: movie, youtubeID: movieYoutube.videoId)
        }
    }
}
