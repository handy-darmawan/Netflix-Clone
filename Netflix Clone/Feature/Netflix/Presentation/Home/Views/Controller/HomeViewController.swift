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
 3. NetworkManager -> Too much boiler plate code to fetch and parsing API
 -> Fix the structure of API Manager
 */
//230 lines

enum Sections: Int, CaseIterable {
    case header
    case trendingMovies
    case popular
    case trendingTV
    case upcomingMovies
    case topRated
    
    var rawValue: String {
        switch self {
        case .trendingMovies: return "Trending Movies"
        case .popular: return "Popular"
        case .trendingTV: return "Trending TV"
        case .upcomingMovies: return "Upcoming Movies"
        case .topRated: return "Top Rated"
        default: return ""
        }
    }
    
    var value: Int {
        switch self {
        case .trendingMovies: return 0
        case .popular: return 1
        case .trendingTV: return 2
        case .upcomingMovies: return 3
        case .topRated: return 4
        default: return 0
        }
    }
    
    var itemCount: Int {
        switch self {
        case .header: return 1
        default: return 2
        }
    }
    
    var innerGroupHeight: NSCollectionLayoutDimension {
        let height = 1.0
        switch self {
        case .header: return .fractionalHeight(height/2)
        default: return .fractionalHeight(height/3)
        }
    }
}


class HomeViewController: UIViewController {
    
    //MARK: DataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Movie>
    
    //MARK: - Attribute
    //    private(set) var tableView: UITableView?
    private(set) var collectionView: UICollectionView?
    //    private(set) var heroHeaderView: HeroHeaderView?
    //    private var randomMovie: Movie?
    private var dataSource: DataSource?
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSnapshots()
    }
    
    //    func setHeroHeaderView() {
    //        NetworkManager.shared.getTrendingMovies { [weak self] results in
    //            guard let self = self else { return }
    //            switch results {
    //            case .success(let movies):
    //                guard let movie = movies.randomElement() else { return }
    //                randomMovie = movie
    //                heroHeaderView?.configure(with: movie)
    //            case .failure(let error):
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
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
        snapshot.appendSections(Sections.allCases)
        
        Task { [ weak self ] in
            guard let self = self else { return }
            
            await homeVM.getTrendingMovies()
            guard let randomMovie = homeVM.movies.value.randomElement() else { return }
            snapshot.appendItems([randomMovie], toSection: .header) //FIXME: the random movie is catch by hashable, so it's not random anymore
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
                let section = Sections(rawValue: indexPath.section)
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
            
            header.textLabel.text = "\(Sections.allCases[indexPath.section].rawValue)"
            header.textLabel.textColor = .white
            header.textLabel.textAlignment = .left
            
            return header
        }
        
    }
    
    //    func setupHeaderView() {
    //        heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 450), playButtonDidTapped: playButtonDidTapped)
    //    }
    
    //    func setupTableView() {
    //        tableView = UITableView(frame: .zero, style: .grouped)
    //        guard let tableView = tableView, let heroHeaderView = heroHeaderView else { return }
    //        view.addSubview(tableView)
    //
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //        tableView.tableHeaderView = heroHeaderView
    //
    //        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.reuseIdentifier)
    //        tableView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        NSLayoutConstraint.activate([
    //            tableView.topAnchor.constraint(equalTo: view.topAnchor),
    //            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    //        ])
    //    }
    
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
            guard let sectionIdentifier = Sections(rawValue: sectionIndex) else { return nil}
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let itemSpacing = 5.0
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupSize, subitem: item, count: sectionIdentifier.itemCount)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: sectionIdentifier.innerGroupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [innerGroup])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            if sectionIdentifier != .header {
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
        //navigating to the movie detail view
        print(indexPath)
    }
}

//extension HomeViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        200
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        40
//    }
//
//    //hide the nav bar when scrolling to bottom direction
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        Sections.allCases[section].rawValue
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.textLabel?.text = Sections.allCases[section].rawValue
//        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
//        header.textLabel?.textColor = .white
//    }
//}

//extension HomeViewController: CollectionItemDelegate {
//    func cellDidTapped(_ cell: CollectionViewTableViewCell, vm: TitlePreviewViewModel, movie: Movie) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//            let vc = TitlePreviewViewController()
//            vc.configure(with: vm, movie: movie)
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}


//
//  HeaderView.swift
//  Compositional Layout
//
//  Created by ndyyy on 13/02/24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = "headerView"
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupLabelConstraints()
    }
    
    private func setupLabelConstraints() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
