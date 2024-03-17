//
//  DataViewModel.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import Foundation

@Observable class DataViewModel {
    var pitchers: [Pitcher] = []
    var teams: [Team] = []
    var signCards: [SignCard] = []
    var games: [Game] = []
    
    init() {
        pitchers.append(Pitcher(first_name: "Ava", last_name: "Senters"))
        pitchers.append(Pitcher(first_name: "Addy", last_name: "Bromberak"))
        
        teams.append(Team(name: "Glory", birth_year: 2013))
        teams.append(Team(name: "Prosper Pride 2k14"))
        
        signCards.append(
            SignCard(
                name: "Card A",
                pitches: [Pitch(number: 100, pitch_type: .FAST, pitch_height: 3, pitch_lateral: 4),
                          Pitch(number: 101, pitch_type: .DROP, pitch_height: 2, pitch_lateral: 3),
                          Pitch(number: 102, pitch_type: .CHANGE, pitch_height: 2, pitch_lateral: 5)]
            )
        )
        
        games.append(
            Game(
                date: Date(timeIntervalSinceNow: 0),
                field_type: .DIRT,
                game_type: .POOL
            )
        )
        games.append(
            Game(
                date: Date(timeIntervalSinceNow: 60*60),
                field_type: .TURF,
                game_type: .BRACKET
            )
        )
    }
}
