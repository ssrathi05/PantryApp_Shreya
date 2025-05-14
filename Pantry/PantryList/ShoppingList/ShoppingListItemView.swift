//
//  ShoppingListItemView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/16/25.
//

import SwiftUI

struct ShoppingListItemView: View {
    
    let item: ShopppingItem
    @EnvironmentObject var viewModel: PantryListViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleItemSelection(item)
            }) {
                Image(systemName: viewModel.isItemSelected(item) ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(viewModel.isItemSelected(item) ? Color("MediumGreen") : .gray)
            }
            
            Text(item.name)
                .font(.system(size: 17))
            Spacer()
            if let quantity = item.exactQuantity {
                Text("x\(quantity)")
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

#Preview {
   
//    let newItem = ShopppingItem(name: "test", exactQuantity: 2, quantityType: "Bottles")
//    return ShoppingListItemView(item: newItem)
//        .environmentObject(PantryListViewModel())
}
