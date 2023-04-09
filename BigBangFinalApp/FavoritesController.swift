//
//  FavoritesController.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 9/4/23.
//

import UIKit

class FavoritesController: UICollectionViewController {
    
    let modelLogic = ModelLogic.shared
    let layout = UICollectionViewFlowLayout()
    let itemWidth = UIScreen.main.bounds.width / 2 - 10
    let itemHeight = UIScreen.main.bounds.width / 2 - 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        NotificationCenter.default.addObserver(forName: .favoritesChange,
                                               object: nil, queue: .main) { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelLogic.getFavoritesRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let episode = modelLogic.getEpisodeFromID(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoritesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.episodeImage.image = UIImage(named: episode.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
