//
//  ModelPersistance.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 7/4/23.
//

import Foundation

final class ModelPersitance {
    static let shared = ModelPersitance()
    
    private let episodesURL = Bundle.main.url(forResource: "BigBang", withExtension: "json")
    let favoritesDocument = URL.documentsDirectory.appending(path: "favorites.json")
    
    private init() {}
    
    func getEpisodes() throws -> [EpisodesModel] {
        guard let episodesURL = episodesURL else { return [] }
        
        if let data = try? Data(contentsOf: episodesURL) {
            return try JSONDecoder().decode([EpisodesModel].self, from: data)
        }
        return []
    }
    
    func saveFavorites(ids:[Int]) throws {
        let favorites = Favorites(ids: ids)
        let data = try JSONEncoder().encode(favorites)
        try data.write(to: favoritesDocument, options: .atomic)
    }
    
    func getFavorites() throws -> [Int] {
        if FileManager.default.fileExists(atPath: favoritesDocument.path()) {
            let data = try Data(contentsOf: favoritesDocument)
            return try JSONDecoder().decode(Favorites.self, from: data).ids
        } else {
            return []
        }
    }
}
