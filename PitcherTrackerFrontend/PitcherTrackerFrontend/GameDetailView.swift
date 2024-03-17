//
//  GameDetailView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct GameDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataViewModel.self) private var dataViewModel
    @State var game: Game
    
    @State private var localFieldType: FieldType = .DIRT
    @State private var localGameType: GameType = .LEAGUE
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var selectedOpponent: Team = Team()
    
    @State private var pickerId: Int = 0
    
    var body: some View {
        List{
            VStack {
                Text("Game Type")
                Picker("Game Type", selection: $localGameType){
                    ForEach(GameType.allCases){category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .id(pickerId)
            }
            .padding()
            
            VStack {
                Text("Field Type")
                Picker("Field Type", selection: $localFieldType){
                    ForEach(FieldType.allCases){category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .id(pickerId)
            }
            .padding()
            
            VStack(alignment: .center){
                Text("Game Date/Time")
                DatePicker("Select a Date",
                           selection: $selectedDate,
                           displayedComponents: .date
                )
                DatePicker("Select a Time",
                           selection: $selectedTime,
                           displayedComponents: .hourAndMinute
                )
            }
            .padding()
            
            VStack{
                Text("Oppenent")
                Picker("Select Team",
                       selection: $selectedOpponent) {
                    ForEach(dataViewModel.teams){team in
                        Text(team.name)
                            .tag(team)
                    }
                }
            }
        }
        .padding(.horizontal, 50)
        .listRowSpacing(20.0)
        .onAppear{
            localGameType = game.game_type
            localFieldType = game.field_type
            selectedDate = game.date
            selectedTime = game.date
            pickerId += 1 // hack to get the Picker to update
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel"){
                    dismiss()
                }
                .font(.title)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    print("Implement save feature!")
                    dismiss()
                }
                .font(.title)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        GameDetailView(game: Game())
            .environment(DataViewModel())
    }
}
