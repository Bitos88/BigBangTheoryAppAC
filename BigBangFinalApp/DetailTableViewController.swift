//
//  DetailTableViewController.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 9/4/23.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var selectedEpisode:EpisodesModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureOutlets()
    }
    
    @IBAction func navigateToIMDB(_ sender: Any) {
        guard let urlString = selectedEpisode?.url,
              let url = URL(string: urlString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        }
        
        return 20
    }
    
    func configureOutlets() {
        guard let selectedEpisode else { return }
        episodeTitle.text = selectedEpisode.name
        episodeImageView.image = UIImage(named: selectedEpisode.image)
        seasonLabel.text = "Season: \(selectedEpisode.season)"
        episodeLabel.text = "Episode: \(selectedEpisode.number)"
        airDateLabel.text = "Air Date: \(selectedEpisode.airdate.formattedDate(with: "MMMM yyyy") ?? selectedEpisode.airdate)"
        runTimeLabel.text = "Run Time: \(selectedEpisode.runtime) min."
        summaryLabel.text = selectedEpisode.summary
    }
}

extension String {
    func formattedDate(with format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = format
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        } else {
            return nil
        }
    }
}
