//
//  ContentView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Image(.defaultBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsView()){
                            Image(systemName: "gearshape.fill")
                                .padding()
                                .foregroundStyle(.white)
                                .font(.system(size: 50))
                        }                    }
                    .frame(height: 75)
                    
                    Spacer()

                    Text("Play ball!")
                        .font(.title)
                        .foregroundStyle(.white)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(DataViewModel())
}
