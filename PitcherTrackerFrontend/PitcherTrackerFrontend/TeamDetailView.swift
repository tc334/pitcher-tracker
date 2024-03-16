//
//  TeamDetailView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct TeamDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var team: Team
    enum FocusedField {
        case int, dec
    }
    @FocusState private var focusField: FocusedField?
    @State private var localBirthYearString = ""
    
    var body: some View {
        List{
            TextField("Team Name", text: $team.name)
                .focused($focusField, equals: .int)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)

            TextField("Birth Year", text: $localBirthYearString)
                .focused($focusField, equals: .int)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
                .numbersOnly($localBirthYearString)
        }
        .onAppear{
            UITextField.appearance().clearButtonMode = .whileEditing
            if team.birth_year == 0 {
                localBirthYearString = ""
            } else {
                localBirthYearString = String(team.birth_year)
            }
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
            ToolbarItem(placement: .keyboard){
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        TeamDetailView(team: Team())
    }
}
