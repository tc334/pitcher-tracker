//
//  PitcherModel.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import Foundation

struct Pitcher: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var first_name = ""
    var last_name = ""
}
