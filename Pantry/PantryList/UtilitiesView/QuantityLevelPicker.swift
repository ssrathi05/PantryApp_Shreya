//
//  QuantityLevelPicker.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct QuantityLevelPicker: View {
    @Binding var selectedLevel: String
    let levels = ["Low", "Half", "Full"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(.clear))
                    .frame(height: 40)
                
                // Progress bar
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("LightGreen"))
                    .frame(width: calculateProgressWidth(geometry: geometry), height: 40)
                
                // Text labels
                HStack(spacing: 0) {
                    ForEach(levels, id: \.self) { level in
                        Button(action: {
                            selectedLevel = level
                        }) {
                            Text(level)
                                .font(.system(size: 17))
                                .fontWeight(selectedLevel == level ? .bold : .regular)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                //.padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color("LightGreen"), lineWidth: 1)
            )
        }
        .frame(height: 30)
        
    }
    
    private func calculateProgressWidth(geometry: GeometryProxy) -> CGFloat {
        let index = levels.firstIndex(of: selectedLevel) ?? 0
        let segmentWidth = geometry.size.width / CGFloat(levels.count)
        return segmentWidth * CGFloat(index + 1)
    }
}


