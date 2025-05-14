//
//  OptionPicker.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct OptionPicker: View {
    @Binding var selectedOption: String
    let options: [String]
    let spacing: CGFloat
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            FlowLayout(items: options, spacing: spacing) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    Text(option)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(selectedOption == option ? Color("DarkGreen") : Color("LightGreen"))
                        .foregroundColor(selectedOption == option ? Color.white : Color.black)
                        .fontDesign(.rounded)
                        .fontWeight(.regular)
                        .cornerRadius(20)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .frame(width: geometry.size.width)
        }
        .frame(height: height)
    }
}


