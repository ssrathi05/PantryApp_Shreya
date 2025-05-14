//
//  PantryListViewModel.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/14/25.
//

import Foundation
import SwiftUI

import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import FirebaseAuth

@MainActor
class PantryListViewModel: ObservableObject {
    
    @Published var pantryItems: [GroceryItem] = []
    //@Published var shoppingItems: [GroceryItem] = []
    @Published var recentlyAddedItems: [GroceryItem] = []
    @Published var buyAgainItems: [ShopppingItem] = []
    @Published var shoppingItems: [ShopppingItem] = []
    
    //need to add expiry vaiarble to groceryitem
    @Published var consumedItems: [GroceryItem] = []
    
    // Add selected items state
    @Published var selectedItems: Set<UUID> = []
    
    // Notification state
    @Published var showNotification: Bool = false
    @Published var notificationMessage: String = ""
    @Published var notificationType: NotificationType = .success
    
    enum NotificationType {
        case success
        case error
    }
    
    private var db = Firestore.firestore()
    
    init() {
        Task {
            await fetchPantryItems()
            await fetchRecentlyAddedItems()
            await fetchShoppingItems()
            await fetchConsumedItems()
            await fetchBuyAgainItems()
        }
    }
    
    private func showNotification(message: String, type: NotificationType = .success) {
        notificationMessage = message
        notificationType = type
        showNotification = true
        
        // Auto-dismiss after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.showNotification = false
            }
        }
    }
    
    func addItem(_ item: GroceryItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }
        
        //when creating new tiem need dateCreated vairable
        // Create a new instance with a new UUID
        let newItem = GroceryItem(
            id: UUID(),
            name: item.name,
            exactQuantity: item.exactQuantity,
            quantityType: item.quantityType,
            quantityLevel: item.quantityLevel,
            isExactQuantity: item.isExactQuantity,
            expiryDays: item.expiryDays,
            category: item.category,
            storage: item.storage
        )
        
        do {
            // Add to pantry items
            try await db.collection("users")
                .document(uid)
                .collection("pantryItems")
                .document(newItem.id.uuidString)
                .setData(from: newItem)
            
            // Add to recently added items if not already present
            if !recentlyAddedItems.contains(where: { $0.name == newItem.name }) {
                recentlyAddedItems.insert(newItem, at: 0)
                if recentlyAddedItems.count > 15 {
                    recentlyAddedItems.removeLast()
                }
                
                // Save to Firestore
                try await db.collection("users")
                    .document(uid)
                    .collection("recentlyAddedItems")
                    .document(newItem.id.uuidString)
                    .setData(from: newItem)
                
                // Remove any excess items from Firestore
                if recentlyAddedItems.count > 15 {
                    let excessItems = recentlyAddedItems[15...]
                    for item in excessItems {
                        try await db.collection("users")
                            .document(uid)
                            .collection("recentlyAddedItems")
                            .document(item.id.uuidString)
                            .delete()
                    }
                }
            }
            
            await fetchPantryItems()
            showNotification(message: "Item added to pantry")
        } catch {
            print("DEBUG: Error adding item to Firestore: \(error.localizedDescription)")
            showNotification(message: "Error adding item", type: .error)
        }
    }
    
    //update this
//    func addShoppingItem(_ item: GroceryItem) async {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("DEBUG: No user logged in.")
//            showNotification(message: "Error: Not logged in", type: .error)
//            return
//        }
//        
//        //when creating new tiem need dateCreated vairable
//        // Create a new instance with a new UUID
//        let newItem = GroceryItem(
//            id: UUID(),
//            name: item.name,
//            exactQuantity: item.exactQuantity,
//            quantityType: item.quantityType,
//            quantityLevel: item.quantityLevel,
//            isExactQuantity: item.isExactQuantity,
//            expiryDays: item.expiryDays,
//            category: item.category,
//            storage: item.storage
//        )
//        
//        do {
//            // Add to shopping items
//            try await db.collection("users")
//                .document(uid)
//                .collection("shoppingItems")
//                .document(newItem.id.uuidString)
//                .setData(from: newItem)
//            
//            // Add to buy again items if not already present
//            if !buyAgainItems.contains(where: { $0.name == newItem.name }) {
//                buyAgainItems.insert(newItem, at: 0)
//                if buyAgainItems.count > 15 {
//                    buyAgainItems.removeLast()
//                }
//                
//                // Save to Firestore
//                try await db.collection("users")
//                    .document(uid)
//                    .collection("buyAgainItems")
//                    .document(newItem.id.uuidString)
//                    .setData(from: newItem)
//                
//                // Remove any excess items from Firestore
//                if buyAgainItems.count > 15 {
//                    let excessItems = buyAgainItems[15...]
//                    for item in excessItems {
//                        try await db.collection("users")
//                            .document(uid)
//                            .collection("buyAgainItems")
//                            .document(item.id.uuidString)
//                            .delete()
//                    }
//                }
//            }
//            
//            await fetchShoppingItems()
//            showNotification(message: "Item added to shopping list")
//        } catch {
//            print("DEBUG: Error adding item to Firestore: \(error.localizedDescription)")
//            showNotification(message: "Error adding item", type: .error)
//        }
//    }
//    
    func addShoppingItem(_ item: ShopppingItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }
        
        //when creating new tiem need dateCreated vairable
        // Create a new instance with a new UUID
        let newItem = ShopppingItem(
            id: UUID(),
            name: item.name,
            exactQuantity: item.exactQuantity ?? 0,
            quantityType: item.quantityType ?? "",
            notesText: item.notesText
            
        )
        
        do {
            // Add to shopping items
            try await db.collection("users")
                .document(uid)
                .collection("shoppingItems")
                .document(newItem.id.uuidString)
                .setData(from: newItem)
            
            // Add to buy again items if not already present
            if !buyAgainItems.contains(where: { $0.name == newItem.name }) {
                buyAgainItems.insert(newItem, at: 0)
                if buyAgainItems.count > 15 {
                    buyAgainItems.removeLast()
                }
                
                // Save to Firestore
                try await db.collection("users")
                    .document(uid)
                    .collection("buyAgainItems")
                    .document(newItem.id.uuidString)
                    .setData(from: newItem)
                
                // Remove any excess items from Firestore
                if buyAgainItems.count > 15 {
                    let excessItems = buyAgainItems[15...]
                    for item in excessItems {
                        try await db.collection("users")
                            .document(uid)
                            .collection("buyAgainItems")
                            .document(item.id.uuidString)
                            .delete()
                    }
                }
            }
            
            await fetchShoppingItems()
            showNotification(message: "Item added to shopping list")
        } catch {
            print("DEBUG: Error adding item to Firestore: \(error.localizedDescription)")
            showNotification(message: "Error adding item", type: .error)
        }
    }
    
    func fetchPantryItems() async {
        guard let uid = Auth.auth().currentUser?.uid else { 
            print("DEBUG: No user logged in.")
            return 
        }
        
        do {
            let snapshot = try await db.collection("users")
                .document(uid)
                .collection("pantryItems")
                .getDocuments()
            
            self.pantryItems = snapshot.documents.compactMap { doc -> GroceryItem? in
                if var item = try? doc.data(as: GroceryItem.self) {
                    // Update expiry days before returning the item
                    item.updateExpiryDays()
                    
                    // If item is expired, move it to consumed items
                    if item.isExpired {
                        Task {
                            //ask user if they want to move it
                            //await moveToConsumed(item)
                        }
                        return nil
                    }
                    
                    return item
                }
                return nil
            }
            print("DEBUG: Successfully fetched \(self.pantryItems.count) items")
        } catch {
            print("DEBUG: Failed to fetch pantry items: \(error.localizedDescription)")
        }
    }
    
    func fetchRecentlyAddedItems() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            return
        }
        
        do {
            let snapshot = try await db.collection("users")
                .document(uid)
                .collection("recentlyAddedItems")
                .getDocuments()
            
            self.recentlyAddedItems = snapshot.documents
                .compactMap { doc -> GroceryItem? in
                    if var item = try? doc.data(as: GroceryItem.self) {
                        // Update expiry days before returning the item
                        item.updateExpiryDays()
                        
                        // If item is expired, move it to consumed items
                        if item.isExpired {
                            Task {
                                //await moveToConsumed(item)
                            }
                            return nil
                        }
                        
                        return item
                    }
                    return nil
                }
                .sorted { $0.id.uuidString > $1.id.uuidString } // Sort by most recent
            
            print("DEBUG: Successfully fetched \(self.recentlyAddedItems.count) recently added items")
        } catch {
            print("DEBUG: Failed to fetch recently added items: \(error.localizedDescription)")
        }
    }
    
    func fetchBuyAgainItems() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            return
        }
        
        do {
            let snapshot = try await db.collection("users")
                .document(uid)
                .collection("buyAgainItems")
                .getDocuments()
            
            self.buyAgainItems = snapshot.documents
                .compactMap { doc -> ShopppingItem? in
                    try? doc.data(as: ShopppingItem.self)
                }
                .sorted { $0.id.uuidString > $1.id.uuidString } // Sort by most recent
            
            print("DEBUG: Successfully fetched \(self.buyAgainItems.count) recently added items")
        } catch {
            print("DEBUG: Failed to fetch buy again items items: \(error.localizedDescription)")
        }
    }
    
    func deleteItem(_ item: GroceryItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }
        
        do {
            // Delete from pantry items
            let pantryRef = db.collection("users")
                .document(uid)
                .collection("pantryItems")
                .document(item.id.uuidString)
            
            try await pantryRef.delete()
            print("DEBUG: Deleted from pantryItems collection")
            
            // Delete from recently added items
            let recentRef = db.collection("users")
                .document(uid)
                .collection("recentlyAddedItems")
                .document(item.id.uuidString)
            
            try await recentRef.delete()
            print("DEBUG: Deleted from recentlyAddedItems collection")
            
            // Update local state
            pantryItems.removeAll { $0.id == item.id }
            recentlyAddedItems.removeAll { $0.id == item.id }
            
            showNotification(message: "Item deleted")
            print("DEBUG: Successfully deleted item from all collections and local state")
        } catch {
            print("DEBUG: Error deleting item: \(error.localizedDescription)")
            showNotification(message: "Error deleting item", type: .error)
        }
    }
    
    //update this
    func deleteShoppingItem(_ item: ShopppingItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }
        
        do {
            // Delete from pantry items
            let shoppingRef = db.collection("users")
                .document(uid)
                .collection("shoppingItems")
                .document(item.id.uuidString)
            
            try await shoppingRef.delete()
            print("DEBUG: Deleted from shoppingItems collection")
            
            // Update local state
            shoppingItems.removeAll { $0.id == item.id }
            
            showNotification(message: "Item deleted from shopping list")
            print("DEBUG: Successfully deleted item from all collections and local state")
        } catch {
            print("DEBUG: Error deleting item: \(error.localizedDescription)")
            showNotification(message: "Error deleting item", type: .error)
        }
    }
    
    //update this
    func moveToShoppingList(_ item: GroceryItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }
        let newItem = ShopppingItem(
            id: UUID(),
            name: item.name,
            exactQuantity: item.exactQuantity ?? 0,
            quantityType: item.quantityType ?? "",
            notesText: ""
            
        )
        
        do {
            // Add to shopping list
            try await db.collection("users")
                .document(uid)
                .collection("shoppingItems")
                .document(newItem.id.uuidString)
                .setData(from: newItem)
            
            // Delete from pantry items
            try await db.collection("users")
                .document(uid)
                .collection("pantryItems")
                .document(item.id.uuidString)
                .delete()
            
//            // Remove from recently added items if present
//            if let index = recentlyAddedItems.firstIndex(where: { $0.id == item.id }) {
//                recentlyAddedItems.remove(at: index)
//                try await db.collection("users")
//                    .document(uid)
//                    .collection("recentlyAddedItems")
//                    .document(item.id.uuidString)
//                    .delete()
//            }
            
            await fetchPantryItems()
            await fetchShoppingItems()
            showNotification(message: "Item moved to shopping list")
        } catch {
            print("DEBUG: Error moving item to shopping list: \(error.localizedDescription)")
            showNotification(message: "Error moving item", type: .error)
        }
    }
//    
//    //update this
//    func moveToPantryList(_ item: ShopppingItem) async {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("DEBUG: No user logged in.")
//            showNotification(message: "Error: Not logged in", type: .error)
//            return
//        }
//        
//        
//        
//        let newItem = GroceryItem(
//            id: UUID(),
//            name: item.name,
//            exactQuantity: item.exactQuantity,
//            quantityType: item.quantityType,
//            quantityLevel: "Low",
//            isExactQuantity: true,
//            expiryDays: 3,
//            category: "Fruits",
//            storage: "Pantry"
//        )
//        
//      
//
//        do {
//            // Add to pantry items
//            try await db.collection("users")
//                .document(uid)
//                .collection("pantryItems")
//                .document(newItem.id.uuidString)
//                .setData(from: newItem)
//
//            // Delete from shopping list
//            try await db.collection("users")
//                .document(uid)
//                .collection("shoppingItems")
//                .document(item.id.uuidString)
//                .delete()
//
//            await fetchPantryItems()
//            await fetchShoppingItems()
//            showNotification(message: "Item moved to pantry")
//        } catch {
//            print("DEBUG: Error moving item to pantry list: \(error.localizedDescription)")
//            showNotification(message: "Error moving item", type: .error)
//        }
//    }
    
    func moveToPantryList(_ item: ShopppingItem) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }

        do {
            // Call OpenAI to get category, storage, and expiryDays based on item name
            let aiResult = try await fetchPantryAttributes(for: item.name)

            // Create GroceryItem with AI-enhanced values
            let newItem = GroceryItem(
                id: UUID(),
                name: item.name,
                exactQuantity: item.exactQuantity,
                quantityType: item.quantityType,
                quantityLevel: "Low", // default or change as needed
                isExactQuantity: item.exactQuantity != nil && item.quantityType != nil,
                expiryDays: aiResult.expiryDays,
                category: aiResult.category,
                storage: aiResult.storage
            )

            // Save to pantryItems
            try await db.collection("users")
                .document(uid)
                .collection("pantryItems")
                .document(newItem.id.uuidString)
                .setData(from: newItem)

            // Remove from shoppingItems
            try await db.collection("users")
                .document(uid)
                .collection("shoppingItems")
                .document(item.id.uuidString)
                .delete()

            // Refresh UI
            await fetchPantryItems()
            await fetchShoppingItems()
            showNotification(message: "Item moved to pantry with AI ✨")
        } catch {
            // Print raw error
            print("DEBUG: Error moving item to pantry: \(error.localizedDescription)")
            showNotification(message: "Error using AI", type: .error)
        }
    }


    
    func moveToConsumed(_ item: GroceryItem, isExpired: Bool = false) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            showNotification(message: "Error: Not logged in", type: .error)
            return
        }

        do {
            // Create a copy of the item with updated isExpired status and dateConsumed
            let consumedItem = GroceryItem(
                id: item.id,
                name: item.name,
                exactQuantity: item.exactQuantity,
                quantityType: item.quantityType,
                quantityLevel: item.quantityLevel,
                isExactQuantity: item.isExactQuantity,
                expiryDays: item.expiryDays,
                category: item.category,
                storage: item.storage,
                dateCreated: item.dateCreated,
                dateConsumed: Date(),  // Set the current date as consumption date
                isExpired: isExpired  // Set the expired status
            )
            
            // Add to consumed items
            try await db.collection("users")
                .document(uid)
                .collection("consumedItems")
                .document(consumedItem.id.uuidString)
                .setData(from: consumedItem)

            await fetchPantryItems()
            await fetchConsumedItems()
            showNotification(message: isExpired ? "Item marked as expired" : "Item marked as consumed")
        } catch {
            print("DEBUG: Error moving item to consumed list: \(error.localizedDescription)")
            showNotification(message: "Error moving item", type: .error)
        }
    }

    //update this
    func fetchShoppingItems() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            return
        }
        
        do {
            let snapshot = try await db.collection("users")
                .document(uid)
                .collection("shoppingItems")
                .getDocuments()
            
            self.shoppingItems = snapshot.documents.compactMap { doc -> ShopppingItem? in
                try? doc.data(as: ShopppingItem.self)
            }
            print("DEBUG: Successfully fetched \(self.shoppingItems.count) shopping items")
        } catch {
            print("DEBUG: Failed to fetch shopping items: \(error.localizedDescription)")
        }
    }
    
    func fetchConsumedItems() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in.")
            return
        }
        
        do {
            let snapshot = try await db.collection("users")
                .document(uid)
                .collection("consumedItems")
                .getDocuments()
            
            self.consumedItems = snapshot.documents.compactMap { doc -> GroceryItem? in
                if var item = try? doc.data(as: GroceryItem.self) {
                    // Update expiry days before returning the item
                    item.updateExpiryDays()
                    return item
                }
                return nil
            }
            print("DEBUG: Successfully fetched \(self.consumedItems.count) consumed items")
        } catch {
            print("DEBUG: Failed to fetch consumed items: \(error.localizedDescription)")
        }
    }
    
    // Add statistics calculation functions
    func calculateConsumptionStats() -> (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                                        eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int) {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        
        // Filter items consumed this month
        let thisMonthItems = consumedItems.filter { item in
            guard let dateConsumed = item.dateConsumed else { return false }
            return dateConsumed >= startOfMonth
        }
        
        // Calculate this month's stats
        let thisMonthExpired = thisMonthItems.filter { $0.isExpired }.count
        let thisMonthRegular = thisMonthItems.filter { !$0.isExpired }.count
        let thisMonthTotal = thisMonthItems.count
        
        // Calculate all time stats
        let allTimeExpired = consumedItems.filter { $0.isExpired }.count
        let allTimeRegular = consumedItems.filter { !$0.isExpired }.count
        let allTimeTotal = consumedItems.count
        
        // Return actual counts instead of percentages
        return (thisMonthRegular, thisMonthExpired, thisMonthTotal,
                allTimeRegular, allTimeExpired, allTimeTotal)
    }
    
    // Add selection functions
    func toggleItemSelection(_ item: ShopppingItem) {
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
        } else {
            selectedItems.insert(item.id)
        }
    }
    
    func isItemSelected(_ item: ShopppingItem) -> Bool {
        selectedItems.contains(item.id)
    }
    
    
    func moveSelectedToPantry() async {
        for id in selectedItems {
            if let item = shoppingItems.first(where: { $0.id == id }) {
                await moveToPantryList(item)
            }
        }
        selectedItems.removeAll()
    }
    
    func deleteSelectedItems() async {
        for id in selectedItems {
            if let item = shoppingItems.first(where: { $0.id == id }) {
                await deleteShoppingItem(item)
            }
        }
        selectedItems.removeAll()
    }
    
    func selectAll() {
        selectedItems = Set(shoppingItems.map { $0.id })
    }
    
    func unselectAll() {
        selectedItems.removeAll()
    }
}

extension Array where Element == GroceryItem {
    func groupedByCategory() -> [String: [GroceryItem]] {
        Dictionary(grouping: self, by: { $0.category })
    }
}



//ai


import Foundation

struct PantryAIResult: Codable {
    let expiryDays: Int
    let category: String
    let storage: String
}

func fetchPantryAttributes(for itemName: String) async throws -> PantryAIResult {
    let lowerName = itemName.lowercased()

    for (keyword, result) in pantryDefaults {
        if lowerName.contains(keyword) {
            return PantryAIResult(expiryDays: result.expiryDays, category: result.category, storage: result.storage)
        }
    }

    // fallback if nothing matches
    return PantryAIResult(expiryDays: 14, category: "Other", storage: "Pantry")
}

let pantryDefaults: [String: (category: String, storage: String, expiryDays: Int)] = [
    "apple": ("Fruits", "Pantry", 7),
    "banana": ("Fruits", "Pantry", 5),
    "bread": ("Sweets", "Pantry", 5),
    "milk": ("Dairy", "Fridge", 7),
    "cheese": ("Dairy", "Fridge", 21),
    "chicken": ("Meat", "Fridge", 2), // raw
    "cooked chicken": ("Meat", "Fridge", 3),
    "beef": ("Meat", "Fridge", 3), // raw
    "cooked beef": ("Meat", "Fridge", 4),
    "egg": ("Dairy", "Fridge", 21),
    "lettuce": ("Vegetables", "Fridge", 7),
    "spinach": ("Vegetables", "Fridge", 5),
    "carrot": ("Vegetables", "Fridge", 21),
    "potato": ("Vegetables", "Pantry", 30),
    "onion": ("Vegetables", "Pantry", 30),
    "tomato": ("Vegetables", "Pantry", 5),
    "rice": ("Condiments", "Pantry", 180),
    "pasta": ("Condiments", "Pantry", 180),
    "sugar": ("Condiments", "Pantry", 365),
    "salt": ("Condiments", "Pantry", 365),
    "butter": ("Dairy", "Fridge", 30),
    "yogurt": ("Dairy", "Fridge", 14),
    "ice cream": ("Sweets", "Freezer", 60),
    "fish": ("Seafood", "Fridge", 2),
    "cooked fish": ("Seafood", "Fridge", 3),
    "shrimp": ("Seafood", "Fridge", 2),
    "ketchup": ("Condiments", "Fridge", 180),
    "mustard": ("Condiments", "Fridge", 180),
    "jam": ("Sweets", "Fridge", 60),
    "orange": ("Fruits", "Fridge", 21),
    "strawberry": ("Fruits", "Fridge", 5),
    "blueberry": ("Fruits", "Fridge", 7),
    "cucumber": ("Vegetables", "Fridge", 7),
    "celery": ("Vegetables", "Fridge", 14),
    "corn": ("Vegetables", "Fridge", 5),
    "broccoli": ("Vegetables", "Fridge", 7),
    "cauliflower": ("Vegetables", "Fridge", 7),
    "mushroom": ("Vegetables", "Fridge", 5),
    "tofu": ("Dairy", "Fridge", 7),
    "almond milk": ("Dairy", "Fridge", 10),
    "cereal": ("Sweets", "Pantry", 90),
    "oats": ("Condiments", "Pantry", 180),
    "honey": ("Condiments", "Pantry", 365),
    "maple syrup": ("Condiments", "Fridge", 180),
    "mayonnaise": ("Condiments", "Fridge", 60),
    "chocolate": ("Sweets", "Pantry", 120),
    "nuts": ("Condiments", "Pantry", 120),
    "peanut butter": ("Condiments", "Pantry", 180)
]
