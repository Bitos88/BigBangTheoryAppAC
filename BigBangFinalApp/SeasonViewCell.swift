//
//  SeasonViewCell.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 7/4/23.
//

import UIKit

class SeasonViewCell: UITableViewCell {

    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        seasonImage.image = nil
        seasonLabel.text = nil
    }

}
