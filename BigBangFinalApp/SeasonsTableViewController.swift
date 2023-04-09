//
//  SeasonsTableViewController.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 7/4/23.
//

import UIKit

class SeasonsTableViewController: UITableViewController {
    var logic = ModelLogic.shared
    
    lazy var dataSource: SeasonsDiffableDataSource = {
        SeasonsDiffableDataSource(tableView: tableView) { [self] tableView, indexPath, season in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as? SeasonViewCell
            
            cell?.seasonImage.image = UIImage(named: "season\(season)")
            cell?.seasonLabel.text = "Season: \(season)"
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        dataSource.apply(logic.snapshot)
    }
    
    @IBSegueAction func showEpisodesSegue(_ coder: NSCoder, sender: Any?) -> EpisodesTableViewController? {

        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }

        let episodesVC = EpisodesTableViewController(coder: coder)
        episodesVC?.selectedSeason = logic.seasons[indexPath.row]

        return episodesVC
    }
}
