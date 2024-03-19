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
 3. NetworkManager -> Too much boiler plate code to fetch and parsing API
 -> Fix the structure of API Manager
 */
//230 lines

class HomeViewController: UIViewController {
    //MARK: - DataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeViewModel.Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Sections, Movie>
    
    //MARK: - Attribute
    private(set) var collectionView: UICollectionView?
    //    private var randomMovie: Movie?
    private var dataSource: DataSource?
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSnapshots()
    }
}


//MARK: Actions
extension HomeViewController {
    //    private func playButtonDidTapped(_ vm: TitlePreviewViewModel) {
    //        guard let movie = randomMovie else { return }
    //        DispatchQueue.main.async {
    //            let vc = TitlePreviewViewController()
    //            vc.configure(with: vm, movie: movie)
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }

    private func updateSnapshots() {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeViewModel.Sections.allCases)
        
        Task { [ weak self ] in
            guard let self = self else { return }
            
            await homeVM.getTrendingMovies()
            guard var randomMovie = homeVM.movies.value.randomElement() else { return }
            randomMovie.uuid = randomMovie.uuid + "_header"
            snapshot.appendItems([randomMovie], toSection: .header)
            snapshot.appendItems(homeVM.movies.value, toSection: .trendingMovies)
            
            await homeVM.getPopularMovies()
            snapshot.appendItems(homeVM.movies.value, toSection: .popular)
            
            await homeVM.getTrendingTV()
            snapshot.appendItems(homeVM.movies.value, toSection: .trendingTV)
            
            await homeVM.getUpcomingMovies()
            snapshot.appendItems(homeVM.movies.value, toSection: .upcomingMovies)
            
            await homeVM.getTopRatedMovies()
            snapshot.appendItems(homeVM.movies.value, toSection: .topRated)
            
            DispatchQueue.main.async {
                self.dataSource?.apply(snapshot)
            }
        }
    }
}


//MARK: Setups
private extension HomeViewController {
    func setups() {
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
        print(indexPath)
        //on tap then push to detail view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
