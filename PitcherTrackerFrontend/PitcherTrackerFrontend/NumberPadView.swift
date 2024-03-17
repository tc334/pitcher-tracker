//
//  NumberPadView.swift
//  NumberPad
//
//  Created by Tegan Counts on 3/16/24.
//

import SwiftUI

struct NumberPadView: View{
    @Binding var numStr: String
    @State var title: String = "Default"
    
    var body : some View {
        HStack(spacing: 20) {
            VStack{
                ForEach(datas){i in
                    HStack{
                        ForEach(i.row){j in
                            Button {
                                if j.value == "c"{
                                    numStr = ""
                                } else {
                                    if j.value == "b" {
                                        numStr.removeLast()
                                    }
                                    else {
                                        numStr += j.value
                                    }
                                }
                            } label: {
                                if j.value == "b"{
                                    Image(systemName: "delete.left.fill")
                                        .font(.body)
                                        .padding(.vertical)
                                        .frame(width: 50, height: 60)
                                        .background(.gray)
                                        .cornerRadius(5)
                                } else {
                                    Text(j.value)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .padding(.vertical)
                                        .frame(width: 50, height: 60)
                                        .background(.gray)
                                        .cornerRadius(5)
                                }
                            }
                            
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .buttonStyle(.borderless)
            
            VStack {
                Text(title)
                    .font(.system(size: 30))
                    .bold()
                    .underline()
                    .multilineTextAlignment(.center)
                Text(numStr)
                    .font(.system(size: 40))
                    .frame(width: 100, height: 60)
                    .border(Color.black)
            }
            .frame(width: 125)
            
        }
        .padding()
        .border(Color.black)
    }
}

struct type: Identifiable {
    var id: Int
    var row: [row]
}

struct row: Identifiable {
    var id: Int
    var value: String
}

var datas = [
    type(id: 0, row: [row(id: 0, value: "1"), row(id: 1, value: "2"), row(id: 2, value: "3")]),
    type(id: 1, row: [row(id: 0, value: "4"), row(id: 1, value: "5"), row(id: 2, value: "6")]),
    type(id: 2, row: [row(id: 0, value: "7"), row(id: 1, value: "8"), row(id: 2, value: "9")]),
    type(id: 3, row: [row(id: 0, value: "c"), row(id: 1, value: "0"), row(id: 2, value: "b")])
]


//#Preview {
//    NumberPadView(numStr: String())
//}
