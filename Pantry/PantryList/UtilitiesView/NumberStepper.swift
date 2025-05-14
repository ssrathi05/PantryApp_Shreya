//
//  NumberStepper.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct NumberStepper: View{
    
    @Binding var quantity: Int
    
    var body: some View{
       
            
            HStack() {
                Spacer()
                    .frame(width: 15)
                Button(action: {
                    if quantity > 0 { quantity -= 1 }
                }) {
                    Text("-")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .bold()
                    
                }
                Text("     ")
                
                
                Text("\(quantity)")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.black)
                
                    .background(Color.white)
                    .padding(.horizontal,5)
                    .padding(.vertical, 4)
                
                Text("     ")
                
                Button(action: {
                    quantity += 1
                }) {
                    Text("+")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.black)
                        .bold()
                    
                        .background(Color.white)
                    
                    
                }
                Spacer()
                    .frame(width: 15)
                
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(Color.white)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(.gray), lineWidth: 0.5)
            )
            
        
            
           
        
    }
}

//#Preview {
//    NumberStepper()
//}
