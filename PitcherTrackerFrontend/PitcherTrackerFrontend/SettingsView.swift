//
//  SettingsView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(DataViewModel.self) private var dataViewModel
    
    var body: some View {
        List{
            NavigationLink(destination: PitcherListView()){
                Text("Pitchers")
                    .font(.title)
            }
            NavigationLink(destination: TeamListView()){
                Text("Teams")
                    .font(.title)
            }
        }
        .navigationTitle("Settings")
        .listStyle(.plain)
        .font(.title)
    }
}

#Preview {
    NavigationStack{
        SettingsView()
            .environment(DataViewModel())
    }
}
