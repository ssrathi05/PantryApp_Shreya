//
//  PantryListView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/12/25.
//
import SwiftUI
import SwiftUI

enum DropDownOption: String, CaseIterable {
    case all = "All"
    case pantry = "Pantry"
    case fridge = "Fridge"
    case freezer = "Freezer"
    
}

struct ExpirySectionView: View {
    let category: String
    let items: [GroceryItem]
    let color: Color
    
    var body: some View {
        CategorySectionView(
            category: category,
            items: items,
            color: color,
            showDividers: true
        )
    }
}

struct PantryListView: View {
    @EnvironmentObject var viewModel: PantryListViewModel

    @State var searchTrue = false
    @State var search: String = ""
    @State var showItemView: Bool = false
    @State var showingAddItem: Bool = false
    @State var showFilterView: Bool = false
    @State var selectedList: DropDownOption? = .all
    
    // Add state variables for filter choices
    @State var sortChoice: String = "Category"
    @State var filterChoice: String = ""
    @State var listChoices: Set<String> = ["Pantry", "Fridge", "Freezer"]
    
    var groupedItems: [String: [GroceryItem]] {
        let filteredItems = viewModel.pantryItems.filter { item in
            // First filter by storage type
            let storageMatch = listChoices.contains(item.storage)
            
            // Then filter by category if selected
            let categoryMatch = filterChoice.isEmpty || item.category == filterChoice
            
            // Then filter by search text if there is any
            let searchMatch = search.isEmpty || item.name.localizedCaseInsensitiveContains(search)
            
            return storageMatch && categoryMatch && searchMatch
        }
        
        // Sort the items based on sortChoice
        let sortedItems = filteredItems.sorted { item1, item2 in
            switch sortChoice {
            case "Category":
                return item1.category < item2.category
            case "Expiry Date":
                return item1.expiryDays < item2.expiryDays
            default:
                return item1.category < item2.category
            }
        }
        
        if sortChoice == "Expiry Date" {
            // Group by expiry status
            var expiryGroups: [String: [GroceryItem]] = [:]
            
            for item in sortedItems {
                let group: String
                if item.expiryDays <= 3 {
                    group = "Expiry Soon"
                } else if item.expiryDays <= 7 {
                    group = "Good for a While"
                } else {
                    group = "Fresh"
                }
                
                if expiryGroups[group] == nil {
                    expiryGroups[group] = []
                }
                expiryGroups[group]?.append(item)
            }
            
            return expiryGroups
        } else {
            return sortedItems.groupedByCategory()
        }
    }
    
    var orderedExpiryGroups: [String] {
        ["Expiry Soon", "Good for a While", "Fresh"]
    }
    
    private func getCategoryColor(_ category: String) -> Color {
        if sortChoice == "Expiry Date" {
            switch category {
            case "Expiry Soon":
                return Color("Red")
            case "Good for a While":
                return Color("Yellow")
            case "Fresh":
                return Color("MediumGreen")
            default:
                return .gray
            }
        } else {
            switch category {
            case "Fruits":
                return .yellow
            case "Vegetables":
                return Color("Red")
            case "Dairy":
                return Color("LightBlue")
            case "Meat":
                return Color("Pink")
            case "Beverages":
                return Color("Purple")
            case "Condiments":
                return Color("Orange")
            case "Sweets":
                return Color("DarkBlue")
            default:
                return .gray
            }
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Spacer()
                    .frame(height: 145)
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 10) {
                        if sortChoice == "Expiry Date" {
                            ForEach(orderedExpiryGroups, id: \.self) { category in
                                if let items = groupedItems[category], !items.isEmpty {
                                    ExpirySectionView(
                                        category: category,
                                        items: items,
                                        color: getCategoryColor(category)
                                    )
                                }
                            }
                        } else {
                            ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                                if let items = groupedItems[category], !items.isEmpty {
                                    CategorySectionView(
                                        category: category,
                                        items: items,
                                        color: getCategoryColor(category),
                                        showDividers: true
                                    )
                                }
                            }
                        }
                    }
                }
                .zIndex(0)
            }
            
            VStack {
                Spacer().frame(height: 20)
                if(searchTrue){
                    HStack(spacing: 23) {
                        TextField("Search items...", text: $search)
                            .padding(15)
                            .font(.system(size: 15))
                            .frame(height: 37)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                            .cornerRadius(20)
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        
                        Button{
                            withAnimation(.easeInOut(duration: 0.2)) {
                                searchTrue = false
                                search = ""
                            }
                        }label: {
                            Text("CANCEL")
                                .foregroundStyle(.white)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: 360)
                    .transition(.opacity)
                }
                    //.zIndex(1)
                else {
                    HStack() {
                        Menu {
                            Button(action: {
                                listChoices = ["Pantry", "Fridge", "Freezer"]
                            }) {
                                Text("All")
                                if listChoices.count == 3 {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                            Button(action: {
                                if listChoices.contains("Pantry") {
                                    listChoices.remove("Pantry")
                                } else {
                                    listChoices.insert("Pantry")
                                }
                            }) {
                                Text("Pantry")
                                if listChoices.contains("Pantry") {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                            Button(action: {
                                if listChoices.contains("Fridge") {
                                    listChoices.remove("Fridge")
                                } else {
                                    listChoices.insert("Fridge")
                                }
                            }) {
                                Text("Fridge")
                                if listChoices.contains("Fridge") {
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                            Button(action: {
                                if listChoices.contains("Freezer") {
                                    listChoices.remove("Freezer")
                                } else {
                                    listChoices.insert("Freezer")
                                }
                            }) {
                                Text("Freezer")
                                if listChoices.contains("Freezer") {
                                    Image(systemName: "checkmark")
                                }
                            }
                        } label: {
                            HStack {
                                Text(listChoices.count == 3 ? "All" : listChoices.joined(separator: ", "))
                                    .foregroundStyle(.white)
                                   
                                Spacer()
                                    .frame(maxWidth: 120)
                                    
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                            .frame(width: 200, height: 35)
                            .background(Color("DarkGreen"))
                            .cornerRadius(20)
                            .padding(.vertical, 10)
                            .padding(.leading, 10)
                            
                        }
                        
                        
                        Spacer()
                        Button{
                            withAnimation(.easeInOut(duration: 0.2)) {
                                searchTrue = true
                            }
                        }label:{
                            Image(systemName:"magnifyingglass")
                                .font(.system(size: 23))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                            .frame(width: 20)
                        Button{
                            showFilterView = true
                        }label:{
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 23))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                            .frame(width: 20)
                        
                        
                    }
                    .padding(.horizontal,20)
                }
                
                Spacer()
            }
            .zIndex(1)
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        Button{
                            showingAddItem = true
                        }label:{
                            PlusButtonView()
                        }
                    }
                }
                .frame(maxWidth: 340)
            }
            .zIndex(2)
            
            // Notification Toast
            if viewModel.showNotification {
                VStack {
                    Spacer()
                    HStack {
                        Text(viewModel.notificationMessage)
                            .foregroundStyle(.black)
                            .font(.system(size: 17))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.easeOut(duration: 0.2)) {
                                viewModel.showNotification = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                                .font(.system(size: 17))
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 25)
                    .background(viewModel.notificationType == .success ? Color("LightGreen") : Color("Red"))
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(3)
            }
            
        }
        .sheet(isPresented: $showFilterView) {
            FilterView(
                sortChoice: $sortChoice,
                filterChoice: $filterChoice,
                listChoices: $listChoices
            )
            .presentationDetents([.fraction(0.70)])
            .presentationCornerRadius(45)
        }
        .onAppear {
            Task {
                await viewModel.fetchPantryItems()
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemSearch()
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(45)
        }
    }
}

#Preview {
    PantryListView()
        .environmentObject(PantryListViewModel())
}




