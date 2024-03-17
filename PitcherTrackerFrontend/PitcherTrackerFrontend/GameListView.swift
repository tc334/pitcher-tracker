//
//  GameListView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct GameListView: View {
    @State private var sheetPresented = false
    @Environment(DataViewModel.self) private var dataViewModel
    
    let myHeight = 50.0
    
    var body: some View {
        List(dataViewModel.games){ game in
            NavigationLink{
                GameDetailView(game: game)
            } label:{
                Text(game.date.description + " vs " + game.opponent_id)
                    .frame(height: myHeight)
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
        .navigationTitle("Games")
        .sheet(isPresented: $sheetPresented, content: {
            NavigationStack{
                GameDetailView(game: Game())
            }
        })
        
    }
}

#Preview {
    NavigationStack {
        GameListView()
            .environment(DataViewModel())
    }
}
