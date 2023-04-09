//
//  EpisodesModel.swift
//  BigBangFinalApp
//
//  Created by Alberto Alegre Bravo on 7/4/23.
//

import Foundation

struct EpisodesModel:Codable, Hashable {
    let season:Int
    let number:Int
    let summary:String
    let runtime:Int
    let id:Int
    let airdate:String
    let image:String
    let name:String
    let url:String
}

struct Favorites:Codable {
    let ids:[Int]
}
