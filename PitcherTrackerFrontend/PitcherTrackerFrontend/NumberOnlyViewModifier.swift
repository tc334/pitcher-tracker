//
//  NumberOnlyViewModifier.swift
//  PitcherTrackerFrontend
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI
import Combine

struct NumberOnlyViewModifier: ViewModifier {
    @Binding var text: String
    var includeDecimal = false
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(text), perform: { newValue in
                var numbers = "0123456789"
                let decimalSepeartor: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                   numbers += decimalSepeartor
                }
                if newValue.components(separatedBy: decimalSepeartor).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter {numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            })
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumberOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}
