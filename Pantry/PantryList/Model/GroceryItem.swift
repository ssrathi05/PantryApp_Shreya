//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

import SwiftUI

class GroceryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    var expiryDays: Int  // Changed to var to allow updates
    let category: String
    let storage: String
    let dateCreated: Date  // Added to track creation date
    var isExpired: Bool  // Changed to stored property
    var dateConsumed: Date?  // Added to track when item was consumed
    
    let exactQuantity: Int?       // only if isExactQuantity == true
    let quantityType: String?     // unit (e.g., lbs, cans, etc.) — only if isExactQuantity == true
    let quantityLevel: String?    // low / medium / high — only if isExactQuantity == false
    
    var isExactQuantity: Bool     // toggle switch
    
    init(id: UUID = UUID(),
         name: String,
         exactQuantity: Int? = nil,
         quantityType: String? = nil,
         quantityLevel: String? = nil,
         isExactQuantity: Bool,
         expiryDays: Int,
         category: String,
         storage: String,
         dateCreated: Date = Date(),
         dateConsumed: Date? = nil,
         isExpired: Bool = false) {  // Added isExpired parameter
        
        self.id = id
        self.name = name
        self.expiryDays = expiryDays
        self.category = category
        self.storage = storage
        self.isExactQuantity = isExactQuantity
        self.dateCreated = dateCreated
        self.isExpired = isExpired  // Set from parameter
        self.dateConsumed = dateConsumed

        // Conditional assignments
        if isExactQuantity {
            self.exactQuantity = exactQuantity
            self.quantityType = quantityType
            self.quantityLevel = nil
        } else {
            self.exactQuantity = nil
            self.quantityType = nil
            self.quantityLevel = quantityLevel
        }
    }
    
    // Function to update expiry days based on current date
    func updateExpiryDays() {
        // Only update if not consumed
        guard dateConsumed == nil else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let daysSinceCreation = calendar.dateComponents([.day], from: dateCreated, to: now).day ?? 0
        let originalExpiryDays = expiryDays + daysSinceCreation // Get the original expiry days
        expiryDays = max(0, originalExpiryDays - daysSinceCreation)
        isExpired = expiryDays <= 0  // Update isExpired when expiryDays changes
    }
    
    // Function to set expiry days based on expiration option
    static func calculateExpiryDays(from option: String, customDate: Date? = nil) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        if option == "Custom", let customDate = customDate {
            let days = calendar.dateComponents([.day], from: now, to: customDate).day ?? 0
            return max(0, days)
        }
        
        var dateComponents = DateComponents()
        
        switch option {
        case "1 week":
            dateComponents.day = 7
        case "2 weeks":
            dateComponents.day = 14
        case "1 month":
            dateComponents.month = 1
        case "3 months":
            dateComponents.month = 3
        case "6 months":
            dateComponents.month = 6
        case "1 year":
            dateComponents.year = 1
        default:
            return 0
        }
        
        if let expirationDate = calendar.date(byAdding: dateComponents, to: now) {
            let days = calendar.dateComponents([.day], from: now, to: expirationDate).day ?? 0
            return max(0, days)
        }
        
        return 0
    }
    
    static func == (lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.expiryDays == rhs.expiryDays &&
               lhs.category == rhs.category &&
               lhs.storage == rhs.storage &&
               lhs.dateCreated == rhs.dateCreated &&
               lhs.isExpired == rhs.isExpired &&
               lhs.dateConsumed == rhs.dateConsumed &&
               lhs.isExactQuantity == rhs.isExactQuantity &&
               lhs.exactQuantity == rhs.exactQuantity &&
               lhs.quantityType == rhs.quantityType &&
               lhs.quantityLevel == rhs.quantityLevel
    }
}


class ShopppingItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let notesText: String
    
    let exactQuantity: Int?    // only if isExactQuantity == true
    let quantityType: String?    // unit (e.g., lbs, cans, etc.) — only if isExactQuantity == true
    
    
    init(id: UUID = UUID(),
         name: String,
         exactQuantity: Int,
         quantityType: String,
         notesText: String
         
         ){
        
        self.id = id
        self.name = name
        self.notesText = notesText
       
        self.exactQuantity = exactQuantity
        self.quantityType = quantityType
    }
    
          
}

