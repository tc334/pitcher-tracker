//
//  SignCardPitchDetailView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct SignCardPitchDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var pitch: Pitch
    @Environment(DataViewModel.self) private var dataViewModel
    
    @State var pitchNumberString: String = ""
    @State var pitchHeightString: String = ""
    @State var pitchLateralString: String = ""
    @State var pitchTypeString: String = ""
    
    var body: some View {
        VStack(spacing: 20){
            HStack(spacing: 50) {
                PitchSelectorView(selectedRadioString: $pitchTypeString)
                NumberPadView(numStr: $pitchNumberString, title: "Pitch Number")
            }
            HStack {
                NumberPadView(numStr: $pitchHeightString, title: "Pitch Height")
                Spacer()
                NumberPadView(numStr: $pitchLateralString, title: "Pitch Lateral")
            }
            Spacer()
        }
        .padding(.horizontal)
        .onAppear{
            if pitch.pitch_height > -1 {
                pitchHeightString = String(pitch.pitch_height)
            }
            if pitch.pitch_lateral > -1 {
                pitchLateralString = String(pitch.pitch_lateral)
            }
            pitchTypeString = pitch.pitch_type.rawValue
            pitchNumberString = String(pitch.number)
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
        SignCardPitchDetailView(pitch: Pitch(
            number: 499,
            pitch_type: .FAST,
            pitch_height: 2,
            pitch_lateral: 6
        ))
            .environment(DataViewModel())
    }
}
