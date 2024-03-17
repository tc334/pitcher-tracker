//
//  SignCardDetailView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct SignCardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var signCard: SignCard
    @Environment(DataViewModel.self) private var dataViewModel
    @State private var sheetPresented = false
    
    var body: some View {
        List{
            TextField("Card Name", text: $signCard.name)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
            
            ForEach(signCard.pitches){pitch in
                NavigationLink {
                    SignCardPitchDetailView(pitch: pitch)
                } label: {
                    let foo = String(format: "%03d", pitch.number) + "   " + pitch.pitch_type.rawValue.padding(toLength: 8, withPad: " ", startingAt: 0) + " height: " + String(pitch.pitch_height) + "   lateral: " + String(pitch.pitch_lateral)
                    Text(foo)
                        .font(.system(size: 20, design: .monospaced))
                }
                
            }
        }
        .navigationTitle("Sign Card Detail")
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel"){
                    dismiss()
                }
                .font(.title)
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    sheetPresented.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .padding(.horizontal)
                })
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
        .sheet(isPresented: $sheetPresented, content: {
            NavigationStack{
                SignCardPitchDetailView(pitch: Pitch())
            }
        })
    }
}

#Preview {
    NavigationStack{
        SignCardDetailView(signCard: SignCard(
            name: "Card A",
            pitches: [Pitch(number: 100, pitch_type: .FAST, pitch_height: 3, pitch_lateral: 4),
                      Pitch(number: 101, pitch_type: .DROP, pitch_height: 2, pitch_lateral: 3),
                      Pitch(number: 102, pitch_type: .CURVE, pitch_height: 2, pitch_lateral: 5)]
        ))
        .environment(DataViewModel())
    }
}
