//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

/**
 Update:
 2. HeroHeaderView -> Use UIStackView to make autolayout in button
 */

class HomeViewController: UIViewController {
    //MARK: - DataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Sections, Movie>
    
    //MARK: - Attribute
    private var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureDataSource()
        Task {
            await homeVM.onLoad()
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setup()
    }
}



//MARK: Actions
extension HomeViewController {
    private func navigateToDetailView(with movie: Movie) {
        let detailView = DetailViewController()
        detailView.setMovie(with: movie)
        self.resetNavigationBar()
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeViewModel.Sections.allCases)
        
        guard let headerMovies = homeVM.headerMovies else { return }
        snapshot.appendItems([headerMovies], toSection: .header)
        snapshot.appendItems(homeVM.trendingMovies, toSection: .trendingMovies)
        snapshot.appendItems(homeVM.popularMovies, toSection: .popular)
        snapshot.appendItems(homeVM.trendingTV, toSection: .trendingTV)
        snapshot.appendItems(homeVM.upcomingMovies, toSection: .upcomingMovies)
        snapshot.appendItems(homeVM.topRatedMovies, toSection: .topRated)
        dataSource?.apply(snapshot)
    }
    
    private func resetNavigationBar() {
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
    }
}


//MARK: Setup
private extension HomeViewController {
    func setup() {
        setupCollectionView()
        configureNavbar()
    }
    
    func configureDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
            guard
                let cell = cell,
                let section = HomeViewModel.Sections(rawValue: indexPath.section)
            else { return UICollectionViewCell()}
            
            switch section {
            case .header:
                cell.delegate = self
                cell.configureFor(type: .header, movie: movie)
            default:
                cell.configureFor(type: .normal, movie: movie)
            }
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView
            else {fatalError("Cannot create header")}
            
            let title = "\(HomeViewModel.Sections.allCases[indexPath.section].rawValue)"
            header.configure(with: title)
            return header
        }
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout())
        guard let collectionView = collectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func compositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = HomeViewModel.Sections(rawValue: sectionIndex) else { return nil}
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let itemSpacing = 5.0
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(sectionKind.itemCount)), heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupSize, repeatingSubitem: item, count: sectionKind.itemCount)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: sectionKind.groupWidth, heightDimension: sectionKind.groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [innerGroup])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            if sectionKind != .header {
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            return section
        }
        return layout
    }
    
    func configureNavbar() {
        let netflixLogo = UIImage(named: "netflix48")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil)
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        let playButton = UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [profileButton, playButton]
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie: Movie?
        let section = HomeViewModel.Sections(rawValue: indexPath.section)
        switch section {
        case .header, .trendingMovies: movie = homeVM.headerMovies
        case .popular: movie = homeVM.popularMovies[indexPath.row]
        case .trendingTV: movie = homeVM.trendingTV[indexPath.row]
        case .upcomingMovies: movie = homeVM.upcomingMovies[indexPath.row]
        case .topRated: movie = homeVM.topRatedMovies[indexPath.row]
        default: return
        }
        
        guard let movie = movie else { return }
        navigateToDetailView(with: movie)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}

extension HomeViewController: DetailViewDelegate {
    func itemTapped(for type: ButtonType, with movie: Movie) {
        if type == .play {
            navigateToDetailView(with: movie)
        }
        else if type == .download {
            //TODO: operation to save
            Task { await homeVM.saveMovie(with: movie) }
        }
    }
}
