//
//  GameModel.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import Foundation

enum FieldType: String, Codable, CaseIterable, Identifiable{
    case TURF
    case DIRT
    
    var id: Self {return self}
}

enum GameType: String, Codable, CaseIterable, Identifiable{
    case POOL
    case BRACKET
    case LEAGUE
    case SCRIMMAGE
    
    var id: Self {return self}
}

struct Game: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var date = Date()
    var pitchers_team_id = UUID().uuidString
    var opponent_id = UUID().uuidString
    var field_type: FieldType = .TURF
    var game_type: GameType = .POOL
}
