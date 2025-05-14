//
//  TextFieldView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/27/25.
//

import SwiftUI


struct TextFieldView: View {
    @Binding var binding: String
    var title : String
    var placeholder : String
    var isSecure: Bool = false
    
    var body: some View {
        Text(title)
             .font(.system(size: 13, weight: .medium, design: .rounded))
             .foregroundStyle(.black)
        if isSecure{
            SecureField(placeholder, text: $binding)
                         .padding(15)
                         .font(.system(size: 17, design: .rounded))
                         .background(Color.clear)
                         .frame(height: 40)
                         .overlay(
                             RoundedRectangle(cornerRadius: 20)
                                 .stroke(Color.black, lineWidth: 0.5)
                         )
        }else{
            TextField(placeholder, text: $binding)
                         .padding(15)
                         .font(.system(size: 17, design: .rounded))
                         .background(Color.clear)
                         .frame(height: 40)
                         .overlay(
                             RoundedRectangle(cornerRadius: 20)
                                 .stroke(Color.black, lineWidth: 0.5)
                         )
        }
         
        
    }
}
