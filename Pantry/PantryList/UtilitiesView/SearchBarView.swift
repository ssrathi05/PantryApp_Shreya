//
//  SearchBarView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI


struct SearchBarView: View{
    
    
    @Binding var search : String
    
    var body: some View{
        
        //top nav bar
        HStack(spacing: 23) {
            TextField("Search items...", text: $search)
                .padding(15)
                .font(.system(size: 17, design: .rounded))
                .frame(height: 40)
                .background(Color.white)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 0.5)
                )
                .cornerRadius(20)
            
            
            Button{
                
            }label: {
                Text("Cancel")
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
            }
                
        }
        .frame(maxWidth: 360)
    }
}



