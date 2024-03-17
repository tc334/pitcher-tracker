//
//  SignCardListView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct SignCardListView: View {
    @State private var sheetPresented = false
    @Environment(DataViewModel.self) private var dataViewModel
    
    let myHeight = 50.0
    
    var body: some View {
        List(dataViewModel.signCards){ signCard in
            NavigationLink{
                SignCardDetailView(signCard: signCard)
            } label:{
                Text(signCard.name)
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
        .navigationTitle("Sign Cards")
        .sheet(isPresented: $sheetPresented, content: {
            NavigationStack{
                SignCardDetailView(signCard: SignCard())
            }
        })
        
    }
}

#Preview {
    NavigationStack {
        SignCardListView()
            .environment(DataViewModel())
    }
}
