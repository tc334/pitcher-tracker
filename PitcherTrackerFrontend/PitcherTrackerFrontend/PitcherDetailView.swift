//
//  PitcherDetailView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct PitcherDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var pitcher: Pitcher
    
    var body: some View {
        List{
            TextField("First Name", text: $pitcher.first_name)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)

            TextField("Last Name", text: $pitcher.last_name)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
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
        PitcherDetailView(pitcher: Pitcher())
    }
}
