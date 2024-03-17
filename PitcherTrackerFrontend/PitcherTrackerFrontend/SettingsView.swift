//
//  SettingsView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(DataViewModel.self) private var dataViewModel
    
    let myHeight = 50.0
    
    var body: some View {
        List{
            NavigationLink(destination: GameListView()){
                Text("Games")
                    .frame(height: myHeight)
                    .font(.title)
            }
            NavigationLink(destination: PitcherListView()){
                Text("Pitchers")
                    .font(.title)
                    .frame(height: myHeight)
            }
            NavigationLink(destination: SignCardListView()){
                Text("Sign Cards")
                    .font(.title)
                    .frame(height: myHeight)
            }
            NavigationLink(destination: TeamListView()){
                Text("Teams")
                    .frame(height: myHeight)
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
