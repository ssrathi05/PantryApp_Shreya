//
//  TimeRangeButtons.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct TimeRangeButtons: View {
    @Binding var allTimeButtonTrue: Bool
    
    var body: some View {
        HStack {
            Button {
                allTimeButtonTrue = false
            } label: {
                Text("THIS MONTH")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .frame(width: 180, height: 35)
                    .background(allTimeButtonTrue ? Color(red: 0.949, green: 0.949, blue: 0.949) : Color("LightGreen"))
                    .cornerRadius(12)
            }
            
            Button {
                allTimeButtonTrue = true
            } label: {
                Text("ALL TIME")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .frame(width: 180, height: 35)
                    .background(allTimeButtonTrue ? Color("LightGreen") : Color(red: 0.949, green: 0.949, blue: 0.949))
                    .cornerRadius(12)
            }
        }
    }
}


