//
//  FavoritesCollectionViewCell.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 9/4/23.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var episodeImage: UIImageView!
    
    override func awakeFromNib() {
        episodeImage.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        episodeImage.image = nil
    }
}
