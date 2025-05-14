//
//  ShoppingListView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/12/25.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var viewModel: PantryListViewModel

    @State var searchTrue = false
    @State var search: String = ""
    @State var showItemView: Bool = false
    @State var showingAddItem: Bool = false
    @State var showFilterView: Bool = false
    @State var showMoreView: Bool = false
    @State var selectedList: DropDownOption? = .all
    
    // Add state variables for filter choices
    @State var sortChoice: String = "Category"
    @State var filterChoice: String = ""
    @State var listChoices: Set<String> = ["Pantry", "Fridge", "Freezer"]
    
    // Add state for notification
    @State private var showNotification: Bool = false
    
//    var groupedItems: [String: [ShopppingItem]] {
//        let filteredItems = viewModel.shoppingItems.filter { item in
//            // First filter by storage type
//            //let storageMatch = listChoices.contains(item.storage)
//            
//            // Then filter by category if selected
//            //let categoryMatch = filterChoice.isEmpty || item.category == filterChoice
//            
//            // Then filter by search text if there is any
//            let searchMatch = search.isEmpty || item.name.localizedCaseInsensitiveContains(search)
//            
//            return  searchMatch
//        }
//        
//       
//        return filteredItems
//    }
  
   
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Spacer()
                    .frame(height: 145)
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 10) {
                        let filteredItems = viewModel.shoppingItems.filter { item in
                            // Filter by storage type
                            //let storageMatch = listChoices.contains(item.storage)
                            
                            // Filter by search text if there is any
                            let searchMatch = search.isEmpty || item.name.localizedCaseInsensitiveContains(search)
                            
                            return searchMatch
                        }
                        
                        if !filteredItems.isEmpty {
                            ShoppingCategorySectionView(
                                category: "Items",
                                items: filteredItems,
                                color: Color("DarkGreen"),
                                showDividers: true
                            )
                        }
                    }
                }
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
                } else {
                    HStack() {
                        Text("Shopping List             ")
                            .foregroundStyle(.white)
                            .frame(width: 200, height: 35)
                            .background(Color("DarkGreen"))
                            .cornerRadius(20)
                            .padding(.vertical, 10)
                            .padding(.leading, 10)
                        
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
                            showMoreView = true
                        }label:{
                            Image(systemName: "ellipsis")
                                .font(.system(size: 23))
                                .foregroundStyle(.white)
                                .padding(.trailing, 11)
                        }
                    }
                    .padding(.horizontal,20)
                }
                
                Spacer()
            }
            
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
            
            // Bottom Action Bar
            if !viewModel.selectedItems.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Button(action: {
                            Task {
                                await viewModel.moveSelectedToPantry()
                            }
                        }) {
                            Text("Move to pantry")
                                .foregroundStyle(.white)
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal, 15)
                                .background(Color("MediumGreen"))
                                .cornerRadius(30)
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.deleteSelectedItems()
                            }
                        }) {
                            Text("Delete")
                                .foregroundStyle(.white)
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal, 15)
                                .background(Color("MediumGreen"))
                                .cornerRadius(30)
                        }
                        Spacer()
                    }
                    .padding()
                    
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
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
            }
         
            if showMoreView{
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .background(Color.black)
                        .opacity(showMoreView ? 0.3 : 0)
                        .ignoresSafeArea()
                        .onTapGesture { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMoreView = false
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: showMoreView)
                    
                    
                        MoreView(isShowing: $showMoreView)
                            .frame(width: 180)
                            .frame(maxHeight: .infinity)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut(duration: 0.3), value: showMoreView)
                }
                
            }
                
        }
        
        .onAppear {
            Task {
                await viewModel.fetchShoppingItems()
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemSearch(isShopping: true)
                .presentationDetents([.fraction(0.99)])
                .presentationCornerRadius(45)
        }
        
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(PantryListViewModel())
}
