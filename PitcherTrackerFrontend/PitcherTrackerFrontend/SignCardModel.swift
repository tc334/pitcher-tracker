//
//  SignCardModel.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import Foundation

enum PitchType: String, Codable, CaseIterable{
    case FAST
    case CHANGE
    case DROP
    case CURVE
    case SCREW
    case RISE
}

struct Pitch: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var number = 0
    var pitch_type: PitchType = .FAST
    var pitch_height = -1
    var pitch_lateral = -1
}

struct SignCard: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var name = ""
    var pitches: [Pitch] = []
}
