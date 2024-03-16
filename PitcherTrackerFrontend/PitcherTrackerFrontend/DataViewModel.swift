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
    
    init() {
        pitchers.append(Pitcher(first_name: "Ava", last_name: "Senters"))
        pitchers.append(Pitcher(first_name: "Addy", last_name: "Bromberak"))
        
        teams.append(Team(name: "Glory", birth_year: 2013))
        teams.append(Team(name: "Prosper Pride 2k14"))
    }
}
