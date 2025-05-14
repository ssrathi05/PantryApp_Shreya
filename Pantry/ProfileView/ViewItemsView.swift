//
//  ViewItemsView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct ViewItemsView: View {
    @EnvironmentObject var viewModel: PantryListViewModel
    
    let allTime: Bool
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Expired Items Section
                    if !expiredItems.isEmpty {
                        CategorySectionView(
                            category: "Expired",
                            items: expiredItems,
                            color: .red,
                            showDividers: true
                        )
                    }
                    
                    // Consumed Items Section
                    if !regularConsumedItems.isEmpty {
                        CategorySectionView(
                            category: "Consumed",
                            items: regularConsumedItems,
                            color: Color("DarkGreen"),
                            showDividers: true
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle(allTime ? "All Time Items" : "This Month's Items")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var expiredItems: [GroceryItem] {
        let items = allTime ? viewModel.consumedItems : thisMonthItems
        return items.filter { $0.isExpired }
    }
    
    private var regularConsumedItems: [GroceryItem] {
        let items = allTime ? viewModel.consumedItems : thisMonthItems
        return items.filter { !$0.isExpired }
    }
    
    private var thisMonthItems: [GroceryItem] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        
        return viewModel.consumedItems.filter { item in
            guard let dateConsumed = item.dateConsumed else { return false }
            return dateConsumed >= startOfMonth
        }
    }
}

struct ConsumedItemCellView: View {
    let item: GroceryItem
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.system(size: 16))
            
            Spacer()
            
            if let dateConsumed = item.dateConsumed {
                Text(formatDate(dateConsumed))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

//struct CategorySectionView: View {
//    let category: String
//    let items: [GroceryItem]
//    let color: Color
//    let showDividers: Bool
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white)
//                .frame(width: 360)
//                .shadow(color: Color.gray.opacity(0.12), radius: 7, x: 4, y: 4)
//            
//            HStack(spacing: 7) {
//                Rectangle()
//                    .fill(color)
//                    .frame(width: 19)
//                
//                VStack(alignment: .leading) {
//                    HeaderItemCellView(category: category)
//                        .foregroundStyle(color)
//                    
//                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
//                        ConsumedItemCellView(item: item)
//                        
//                        if showDividers && index < (items.count - 1) {
//                            Rectangle()
//                                .frame(height: 1)
//                                .foregroundColor(.lightGray)
//                                .padding(.horizontal, 10)
//                        }
//                    }
//                }
//                .padding(.vertical, 10)
//            }
//            .frame(width: 360)
//            .cornerRadius(15)
//        }
//    }
//}

#Preview {
    ViewItemsView(allTime: false)
        .environmentObject(PantryListViewModel())
}

//create a struct for ViewItemCellView
