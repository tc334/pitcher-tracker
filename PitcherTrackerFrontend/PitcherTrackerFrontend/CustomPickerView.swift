//
//  CustomPickerView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct CustomPickerView: View {
    @State var selectedTeam: Team
    @Environment(DataViewModel.self) private var dataViewModel
    
    var body: some View {
        Menu{
            Picker("Pick an opponent", selection: $selectedTeam) {
                ForEach(dataViewModel.teams){team in
                    Text(team.prettyName())
                        .tag(team)
                        .font(.title)
                }
            }
            .scaleEffect(2.0)
            .frame(maxWidth: .infinity)
        } label: {
            Text(selectedTeam.prettyName())
                .font(.title)
        }.id(selectedTeam)
    }
}

#Preview {
    CustomPickerView(selectedTeam: Team(name: "Blank"))
        .environment(DataViewModel())
}
