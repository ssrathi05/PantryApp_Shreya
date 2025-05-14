//
//  DropDownPickerView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/15/25.
//

import SwiftUI

enum DropDownPickerPostion {
    case top
    case bottom
}

struct DropDownPicker1: View {
    @Binding var selection: DropDownOption?
    var postion: DropDownPickerPostion = .bottom
    var options: [DropDownOption]
    var maxWidth: CGFloat = 200
    
    @State private var isDropDownVisible = false
    @SceneStorage("drop_down_zindex") private var zIndex = 1000.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if postion == .top && isDropDownVisible {
                    optionsView()
                }
                triggerView()
                if postion == .bottom && isDropDownVisible {
                    optionsView()
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .frame(maxWidth: maxWidth)
        }
        .frame(width: maxWidth, height: 40)
        .zIndex(zIndex)
    }
    
    private func triggerView() -> some View {
        HStack {
            Text(selection?.rawValue ?? "All")
                .foregroundStyle(.white)
                .font(.system(size: 17))
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "chevron.down")
                .font(.system(size: 20))
                .foregroundStyle(.white)
        }
        .padding()
        .frame(height: 40)
        .background(Color("DarkGreen"))
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut) {
                isDropDownVisible.toggle()
                zIndex += 1
            }
        }
        .zIndex(10)
        .cornerRadius(20)
    }
    
    private func optionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option.rawValue)
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .opacity(selection == option ? 1 : 0)
                }
                .frame(height: 40)
                .padding(.horizontal, 15)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selection = option
                        isDropDownVisible.toggle()
                    }
                }
                .background(selection == option ? Color("LightGreen") : Color.white)
            }
        }
        .transition(.slide)
        .zIndex(1)
    }
}


