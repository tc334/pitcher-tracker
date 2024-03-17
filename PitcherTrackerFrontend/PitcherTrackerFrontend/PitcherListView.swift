//
//  PitcherListView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct PitcherListView: View {
    @State private var sheetPresented = false
    @Environment(DataViewModel.self) private var dataViewModel
    
    let myHeight = 50.0
    
    var body: some View {
        List(dataViewModel.pitchers){ pitcher in
            NavigationLink{
                PitcherDetailView(pitcher: pitcher)
            } label:{
                Text(pitcher.first_name + " " + pitcher.last_name)
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
        .navigationTitle("Pitchers")
        .sheet(isPresented: $sheetPresented, content: {
            NavigationStack{
                PitcherDetailView(pitcher: Pitcher())
            }
        })
        
    }
}

#Preview {
    NavigationStack {
        PitcherListView()
            .environment(DataViewModel())
    }
}
