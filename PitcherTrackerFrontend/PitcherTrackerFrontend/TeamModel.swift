//
//  TeamModel.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import Foundation

struct Team: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var name = ""
    var birth_year = 0
    
    func prettyName() -> String {
        let a = name + " (" + String(birth_year) + ")"
        return a
    }
}
