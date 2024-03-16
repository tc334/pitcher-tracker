//
//  PitcherTrackerFrontendApp.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

@main
struct PitcherTrackerFrontendApp: App {
    @State private var dataViewModel = DataViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataViewModel)
        }
    }
}
