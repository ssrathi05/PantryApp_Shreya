//
//  PantryListView2.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/14/25.
//

import SwiftUI


struct PantryListView2: View {
    @State private var pantryItems = samplePantryItems
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category).font(.headline)) {
                        ForEach(groupedItems[category] ?? []) { item in
                            HStack {
                                Text(item.name)
                                    .font(.body)
                                Spacer()
                                ExpiryIndicator(expiryDays: item.expiryDays)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeItem(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    markAsConsumed(item)
                                } label: {
                                    Label("Consumed", systemImage: "checkmark")
                                        .foregroundColor(.blue)
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pantry List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
    
    private var groupedItems: [String: [PantryItem]] {
        Dictionary(grouping: pantryItems, by: { $0.category })
    }
    
    func removeItem(_ item: PantryItem) {
        pantryItems.removeAll { $0.id == item.id }
    }
    
    func markAsConsumed(_ item: PantryItem) {
        pantryItems.removeAll { $0.id == item.id }
    }
    
    func addItem() {
        pantryItems.append(PantryItem(name: "New Item", category: "Others", expiryDays: 5))
    }
}

struct ExpiryIndicator: View {
    var expiryDays: Int
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(expiryDays > 5 ? .green : expiryDays > 2 ? .orange : .red)
            Text("\(expiryDays)d")
                .foregroundColor(.gray)
        }
    }
}




#Preview {
    PantryListView2()
}

struct PantryItem: Identifiable {
    let id = UUID()
    var name: String
    var category: String
    var expiryDays: Int
}

let samplePantryItems: [PantryItem] = [
    PantryItem(name: "Apples", category: "Fruits", expiryDays: 7),
    PantryItem(name: "Bananas", category: "Fruits", expiryDays: 10),
    PantryItem(name: "Strawberries", category: "Fruits", expiryDays: 3),
    PantryItem(name: "Pineapples", category: "Fruits", expiryDays: 1),
    PantryItem(name: "Kale", category: "Vegetables", expiryDays: 3),
    PantryItem(name: "Broccoli", category: "Vegetables", expiryDays: 5),
    PantryItem(name: "Green Beans", category: "Vegetables", expiryDays: 7),
    PantryItem(name: "Onions", category: "Vegetables", expiryDays: 12),
    PantryItem(name: "Cheddar Cheese", category: "Dairy", expiryDays: 14)
]
