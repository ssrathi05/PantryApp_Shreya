//
//  ItemCellView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/14/25.
//

import SwiftUI


struct SingleItemCellView: View {
    let item: GroceryItem
    @EnvironmentObject var viewModel: PantryListViewModel
    
    @State private var offsetX: CGFloat = 0
    @State private var showConfirmationDialog: Bool = false
    @State private var selectedAction: String = ""
    @State private var wasConsumed: Bool = false
    
    var body: some View {
        ZStack {
            // BACKGROUND: Swipe action buttons
            HStack(spacing: 0) {
                // --- RIGHT SWIPE: consume ---
                if offsetX > 50 {
                    Button(action: {
                        selectedAction = "consume"
                        showConfirmationDialog = true
                    }) {
                        VStack {
                            Text("Consumed")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                
                                .padding(.vertical, 8)
    
                        }
                        .frame(width: 100)
                        .foregroundColor(.white)
                        .background(Color("DarkBlue"))
                     
                    }
                }

                Spacer()

                // --- LEFT SWIPE: delete ---
                if offsetX < -50 {
                    Button(action: {
                        selectedAction = "delete"
                        showConfirmationDialog = true
                    }) {
                        VStack {
                            Text("Remove")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                        }
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .background(Color("Red"))
                        
                    }
                }
            }

            // FOREGROUND: The actual item card
            HStack {
                Text(item.name)
                    .font(.system(size: 17))
                Spacer()
                ExpiryIndicator(expiryDays: item.expiryDays)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 8)
            .background(Color.white)
            .contentShape(Rectangle())
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offsetX = gesture.translation.width
                    }
                    .onEnded { _ in
                        if abs(offsetX) < 50 {
                            offsetX = 0
                        } else {
                            offsetX = offsetX > 0 ? 100 : -100
                        }
                    }
            )
            .animation(.spring(), value: offsetX)
        }
        .frame(height: 28)
        .confirmationDialog(
            selectedAction == "consume" ? "Was the food eaten?" : 
            selectedAction == "postConsume" ? "What would you like to do with this item?" : 
            "Are you sure you want to delete?",
            isPresented: $showConfirmationDialog,
            titleVisibility: .visible
        ) {
            if selectedAction == "consume" {
                Button("Yes, I ate it") {
                    wasConsumed = true
                    Task {
                        await viewModel.moveToConsumed(item)
                        // Show second confirmation dialog
                        selectedAction = "postConsume"
                        showConfirmationDialog = true
                    }
                }
                Button("No, it expired") {
                    wasConsumed = false
                    Task {
                        await viewModel.moveToConsumed(item, isExpired: true)
                        item.isExpired = true
                        // Show second confirmation dialog
                        selectedAction = "postConsume"
                        showConfirmationDialog = true
                    }
                }
                Button("Cancel", role: .cancel) {}
            } else if selectedAction == "postConsume" {
                Button("Move to shopping cart") {
                    Task {
                        await viewModel.moveToShoppingList(item)
                    }
                }
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteItem(item)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } else {
                Button("Move to shopping cart") {
                    Task {
                        await viewModel.moveToShoppingList(item)
                    }
                }
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteItem(item)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}


struct HeaderItemCellView: View{
    
    var category: String;
    
    var body: some View{
        
        HStack{
            Text(category.uppercased())
                .fontWeight(.bold)
                .font(.system(size: 13))
            Spacer()
            
        }
        .frame(width: 350)
        .padding(5)
    }
}

#Preview{
    let item = GroceryItem(name: "potatoes", isExactQuantity: true, expiryDays: 3, category: "Vegetables", storage: "Pantry")
    SingleItemCellView(item: item)
        .environmentObject(PantryListViewModel())
    
    
}
