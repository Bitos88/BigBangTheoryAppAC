//
//  EpisodesTableViewController.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 8/4/23.
//

import UIKit

class EpisodesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var logic = ModelLogic.shared
    var selectedSeason:Int?
    
    lazy var episodesDataSource: EpisodesDiffableDataSource = {
        EpisodesDiffableDataSource(tableView: tableView) { [weak self] table, indexPath, episode in
            self?.logic.getContentForRow(tableView: table, indexPath: indexPath, episode: episode)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDataSource()
        configureNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        1
    }
    
    private func configDataSource() {
        guard let selectedSeason = selectedSeason else { return }
        tableView.dataSource = episodesDataSource
        episodesDataSource.apply(logic.getEpisodesSnapshot(season: selectedSeason))
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text,
        let selectedSeason = selectedSeason else { return }
        logic.search = search
        episodesDataSource.apply(logic.getEpisodesSnapshot(season: selectedSeason), animatingDifferences: true)
    }
    
    func configureNavigationBar() {
        guard let selectedSeason = selectedSeason else { return }
        
        let searchController = logic.getSearchBar()
        searchController.searchResultsUpdater = self
        title = "Episodes season \(selectedSeason)"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let episode = logic.getEpisodeRow(indexPath: indexPath)
//        let action = UIContextualAction(style: logic.isFavorite(episode: episode) ? .destructive : .normal, title: "Fav") { [self] _, _, handler in
//            logic.toggleFavorite(episode: episode)
//            handler(true)
//        }
//        action.image = UIImage(systemName: logic.isFavorite(episode: episode) ? "star" : "star.fill")
//        action.backgroundColor = logic.isFavorite(episode: episode) ? .green : .cyan
//        return UISwipeActionsConfiguration(actions: [action])
//    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let episode = episodesDataSource.itemIdentifier(for: indexPath) else { return nil }
        let action = UIContextualAction(style: logic.isFavorite(episode: episode) ? .destructive : .normal, title: "F") { [self] _, _, handler in
            logic.toggleFavorite(episode: episode)
            handler(true)
        }
        action.image = UIImage(systemName: logic.isFavorite(episode: episode) ? "star" : "star.fill")
        action.backgroundColor = logic.isFavorite(episode: episode) ? .red : .blue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow,
              let detailViewController = segue.destination as? DetailTableViewController,
              let selectedSeason else { return }
        
        if segue.identifier == "detailSegue" {
            detailViewController.selectedEpisode = logic.getDetailEpisode(season: selectedSeason, episode: indexPath.row)
        }
    }
}
