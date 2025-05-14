//
//  CategorySectionView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/17/25.
//

import SwiftUI

struct CategorySectionView: View {
    let category: String
    let items: [GroceryItem]
    let color: Color
    let showDividers: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 360)
                .shadow(color: Color.gray.opacity(0.12), radius: 7, x: 4, y: 4)
            
            HStack(spacing: 7) {
                Rectangle()
                    .fill(color)
                    .frame(width: 19)
                
                VStack(alignment: .leading) {
                    HeaderItemCellView(category: category)
                        .foregroundStyle(color)
                    
//                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
//                        SingleItemCellView(item: item)
//                        
//                        if showDividers && index < (items.count - 1) {
//                            Rectangle()
//                                .frame(height: 1)
//                                .foregroundColor(.lightGray)
//                                .padding(.horizontal, 10)
//                        }
//                    }
                    
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        
                        SingleItemCellView(item: item)
                        
                        if showDividers && index < (items.count - 1) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.lightGray)
                                .padding(.horizontal, 10)
                        }
                    }

                }
                .padding(.vertical, 10)
            }
            .frame(width: 360)
            .cornerRadius(15)
        }
    }
}

