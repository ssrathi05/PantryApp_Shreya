//
//  BackgroundView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct BackgroundView: View{
    
    var body: some View{
        VStack{
            Rectangle()
                .frame(height: 300)
                .foregroundStyle(Color("MediumGreen"))
               
            Spacer()
            
        }
        .ignoresSafeArea()
        
        Rectangle()
            .foregroundStyle(.white)
            
            .frame(width: 400, height: 630)
            .cornerRadius(50)
            .padding(.top,85)
            .padding(.horizontal,10)
        
    }
}

#Preview {
    BackgroundView()
}
