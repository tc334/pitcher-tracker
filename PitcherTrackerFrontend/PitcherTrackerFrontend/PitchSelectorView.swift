//
//  PitchSelectorView.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct PitchSelectorView: View {
    @Binding var selectedRadioString: String
    
    var body: some View {
        VStack(spacing: 10){
            ForEach(PitchType.allCases, id: \.self){enumCase in
                Button(action: {
                    selectedRadioString = enumCase.rawValue
                }, label: {
                    RadioListTextView(selectedText: $selectedRadioString, myText: enumCase.rawValue)
                })
            }
        }
    }
}

struct FieldTypeSelectorView: View {
    @Binding var selectedRadioString: String
    
    var body: some View {
        VStack(spacing: 10){
            ForEach(FieldType.allCases, id: \.self){enumCase in
                Button(action: {
                    selectedRadioString = enumCase.rawValue
                }, label: {
                    RadioListTextView(selectedText: $selectedRadioString, myText: enumCase.rawValue)
                })
            }
        }
    }
}

struct GameTypeSelectorView: View {
    @Binding var selectedType: GameType
    
    var body: some View {
        VStack(spacing: 10){
            ForEach(GameType.allCases, id: \.self){enumCase in
                Button(action: {
                    selectedType = enumCase
                }, label: {
                    GameTypeRadioListTextView(selectedValue: $selectedType, myValue: enumCase)
                })
            }
        }
    }
}

struct GameTypeRadioListTextView: View {
    @Binding var selectedValue: GameType
    var myValue: GameType
    
    var body: some View {
        Text(myValue.rawValue)
            .font(.title2)
            .bold()
            .frame(width: 150)
            .foregroundColor(selectedValue == myValue ? Color.black : Color.white)
            .padding(.vertical, 5)
            .background(.gray)
    }
}


struct RadioListTextView: View {
    @Binding var selectedText: String
    var myText: String
    
    var body: some View {
        Text(myText)
            .font(.title2)
            .bold()
            .frame(width: 110)
            .foregroundColor(selectedText == myText ? Color.black : Color.white)
            .padding(.vertical, 5)
            .background(.gray)
    }
}

//#Preview {
//    PitchSelectorView()
//}
