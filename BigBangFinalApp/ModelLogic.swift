//
//  ModelLogic.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 7/4/23.
//

import UIKit

final class ModelLogic {
    static let shared = ModelLogic()
    
    let persistance = ModelPersitance.shared
    var search = ""
    var filteredEpisodes:[EpisodesModel] {
        episodes
            .filter {
                if search.isEmpty {
                    return true
                } else {
                    return $0.name.lowercased().contains(search.lowercased())
                }
            }
    }
    
    var episodes = [EpisodesModel]()
    var seasons:[Int] {
        Array(Set(episodes.map(\.season))).sorted { $0 < $1 }
    }
    
    var snapshot:NSDiffableDataSourceSnapshot<String, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<String, Int>()
        snapshot.appendSections([""])
        snapshot.appendItems(seasons)
        
        return snapshot
    }
    
    private var favorites:[Int] {
        didSet {
            try? persistance.saveFavorites(ids: favorites)
            NotificationCenter.default.post(name: .favoritesChange, object: nil)
        }
    }
    
    init() {
        do {
            episodes = try persistance.getEpisodes()
            favorites = try persistance.getFavorites()
        } catch {
            episodes = []
            favorites = []
        }
    }
    
    func getFavoritesRows() -> Int {
        favorites.count
    }
    
    func isFavorite(episode:EpisodesModel) -> Bool {
        favorites.contains(episode.id)
    }
    
    func toggleFavorite(episode:EpisodesModel) {
        if favorites.contains(episode.id) {
            favorites.removeAll(where: { $0 == episode.id })
        } else {
            favorites.append(episode.id)
        }
    }
    
    func getEpisodesSnapshot(season: Int) -> NSDiffableDataSourceSnapshot<String, EpisodesModel> {
        var snapshot = NSDiffableDataSourceSnapshot<String, EpisodesModel>()
        snapshot.appendSections(["EPISODES"])
        
        let episodesBySeason = getEpisodesBySeason(season: season)
        snapshot.appendItems(episodesBySeason, toSection: "EPISODES")
        
        return snapshot
    }
    
    func getEpisodesBySeason(season:Int) -> [EpisodesModel] {
        let episodes = filteredEpisodes.filter { episode in
            episode.season == season
        }
        return episodes
    }
    
    func getEpisodeRow(indexPath: IndexPath) -> EpisodesModel {
        filteredEpisodes[indexPath.row]
    }
    
    func getContentForRow(tableView:UITableView, indexPath: IndexPath, episode: EpisodesModel) -> UITableViewCell {
        var content = UIListContentConfiguration.subtitleCell()
        content.text = episode.name
        content.image = UIImage(named: episode.image)
        content.imageProperties.maximumSize = CGSize(width: 100, height: 80)
        content.imageProperties.cornerRadius = 10
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodesCell", for: indexPath)
        
        cell.contentConfiguration = content
                    
        return cell
    }
    
    func getSearchBar() -> UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Enter a episode name"
        search.obscuresBackgroundDuringPresentation = false
        return search
    }
    
    func getDetailEpisode(season:Int, episode:Int) -> EpisodesModel {
        let episodesList = getEpisodesBySeason(season: season)
        return episodesList[episode]
    }
    
    func getEpisodeFromID(indexPath:IndexPath) -> EpisodesModel? {
        let id = favorites[indexPath.row]
        return filteredEpisodes.first { episode in
            episode.id == id
        }
    }
}

extension Notification.Name {
    static let favoritesChange = Notification.Name("FAVCHANGES")
}
