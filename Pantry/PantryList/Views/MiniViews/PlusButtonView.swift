//
//  PlusButtonView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct PlusButtonView: View{
    
    var body: some View{
        ZStack{
            Circle()
                .foregroundStyle(Color("DarkGreen"))
                .frame(width: 55)
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .font(.system(size: 30))
                .bold()
        }
        
    }
}

#Preview {
    PlusButtonView()
}
