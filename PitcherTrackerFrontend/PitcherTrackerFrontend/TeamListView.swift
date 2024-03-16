//
//  TeamListView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct TeamListView: View {
    @State private var sheetPresented = false
    @Environment(DataViewModel.self) private var dataViewModel
    
    var body: some View {
        List(dataViewModel.teams){ team in
            NavigationLink{
                TeamDetailView(team: team)
            } label:{
                Text(team.name + " (" + String(team.birth_year) + ")")
            }
            .font(.title2)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {sheetPresented.toggle()},
                       label: {Image(systemName: "plus")}
                )
            }
        }
        .navigationTitle("Teams")
        .sheet(isPresented: $sheetPresented, content: {
            NavigationStack{
                TeamDetailView(team: Team())
            }
        })
        
    }
}

#Preview {
    NavigationStack {
        TeamListView()
            .environment(DataViewModel())
    }
}
