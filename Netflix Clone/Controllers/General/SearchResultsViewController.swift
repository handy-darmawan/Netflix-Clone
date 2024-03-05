//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by ndyyy on 29/02/24.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTap(vm: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    var data: [Movie] = []
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func update(with results: [Movie]) {
        data = results
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexpath: IndexPath) {
        dump(data[indexpath.row])
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseIdentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: data[indexPath.row].posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = data[indexPath.row]
        guard
            let movieTitle = movie.originalTitle ?? movie.originalName,
            let movieOverview = movie.overview
        else { return }
        
        APIManager.shared.getMovieDetail(with: movieTitle) { [ weak self ] results in
            guard let self = self else { return }
            switch results {
            case .success(let movieDetail):
                let vm = TitlePreviewViewModel(title: movieTitle, youtubeView: movieDetail, titleOverview: movieOverview)
                delegate?.didTap(vm: vm)
            case .failure(let error):
                print(error)
            }
        }
    }
}
