//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by ndyyy on 26/02/24.
//

import UIKit

//protocol CollectionItemDelegate: AnyObject {
//    func cellDidTapped(_ cell: CollectionViewTableViewCell, vm: TitlePreviewViewModel, movie: Movie)
//}

class CollectionViewTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CollectionViewTableViewCell"
    private var data: [Movie] = []
    
//    weak var delegate: CollectionItemDelegate?
    
    private(set) var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movies: [Movie]) {
        data = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: data[indexPath.row].posterPath!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let title = data[indexPath.row].originalName ?? data[indexPath.row].originalTitle {
//            NetworkManager.shared.getMovieDetail(with: title + " trailer") { [weak self] results in
//                guard let self = self else { return }
//                switch results {
//                case .success(let results):
//                    let vm = TitlePreviewViewModel(title: title, youtubeView: results, titleOverview: data[indexPath.item].overview ?? "This is an overview")
//                    delegate?.cellDidTapped(self, vm: vm, movie: data[indexPath.row])
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
        }
    }
    
    func downloadTitleAt(indexPath: IndexPath) {
        let movie = data[indexPath.row]
//        CoreDataDataSource.shared.save(movie: movie) { results in
//            switch results {
//            case .success(()):
//                print("Saved")
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [ weak self ] _ in
            guard let _ = self else { return nil}
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPaths[0])
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
