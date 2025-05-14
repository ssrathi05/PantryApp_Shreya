//
//  MoveItemToPantryView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/19/25.
//

import SwiftUI

struct MoveItemToPantryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isExactQuantity: Bool = true
    @State var itemName: String
    @State var exactQuantity: Int = 1
    @State var quantityType: String = "Bag(s)"
    @State var quantityLevel: String = "Low"
    @State var category: String = "Fruits"
    @State var storage: String = "Pantry"
    @State var expirationOption: String = "1 week"
    @State var customExpirationDate: Date = Date()
    @State var showDatePicker: Bool = false
    @State var daysUntilExpiration: Int = 7
    
    let quantityTypes = ["Bag(s)", "Bottle(s)", "Box(es)", "Jar(s)", "Bundle(s)","+7"]
    let categoryOptions = ["Fruits", "Vegetables", "Meat","Seafood","Dairy","Beverages","Sweets","Condiments"]
    let storaageOptions = ["Fridge", "Freezer","Pantry","Add Storage Space"]
    let expirationOptions = ["Custom", "1 week", "2 weeks", "1 month", "3 months", "6 months", "1 year"]
    
    @EnvironmentObject var viewModel: PantryListViewModel

    
    var body: some View {
        NavigationView {
            ScrollView{
               
                ZStack {
                    
                    // Centered TextField
                    Text(itemName)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 1)
                        .padding(.horizontal)
                        
                        .bold()
                        .font(.system(size: 24))
                        .underline()
//                        .overlay(
//                            Rectangle()
//                                .frame(height: 1)
//                                .foregroundColor(.black)
//                                .padding(.top, 40),
//                            alignment: .top
//                        )

                    
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 15) {
                    //quanitity
                    Text("QUANTITY")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .bold()
                    
                    if(isExactQuantity) {
                        VStack(alignment: .leading) {
                            NumberStepper(quantity: $exactQuantity)
                            Spacer()
                                .frame(height: 17)
                            // Quantity type options
                            OptionPicker(
                                selectedOption: $quantityType,
                                options: quantityTypes,
                                spacing: 17,
                                height: 1
                            )
                        }
                    } else {
                        QuantityLevelPicker(selectedLevel: $quantityLevel)
                    }
                    
                    //toggle - use exact quanitty instead
                    HStack {
                        Text("Use quantity instead")
                            .font(.system(size: 17))
                        
                        Toggle("", isOn: $isExactQuantity)
                            .toggleStyle(CustomToggleStyle())
                    }
                    .padding(.top, isExactQuantity ? 75 : 0) // Adjust spacing based on isExactQuantity
                    
                    Text("CATEGORY")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .bold()
                    OptionPicker(selectedOption: $category, options: categoryOptions, spacing: 17, height: 150)
                    
                    Text("STORAGE")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .bold()
                    OptionPicker(selectedOption: $storage, options: storaageOptions, spacing: 17, height: 100)
                    
                    HStack {
                        Text("EXPIRATION DATE")
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .bold()
                        
                        Text("\(daysUntilExpiration) days left")
                            .font(.system(size: 13))
                            .foregroundColor(daysUntilExpiration > 5 ? Color("MediumGreen") : daysUntilExpiration > 2 ? Color("Orange") : Color("Red"))
                            .bold()
                    }
                    
                    OptionPicker(
                        selectedOption: $expirationOption,
                        options: expirationOptions,
                        spacing: 17,
                        height: 160
                    )
                    .onChange(of: expirationOption) { newValue in
                        calculateExpirationDate()
                    }
                    Button {
//                        let item = GroceryItem(
//                            name: itemName,
//                            exactQuantity: exactQuantity,
//                            quantityType: quantityType,
//                            quantityLevel: quantityLevel,
//                            isExactQuantity: isExactQuantity,
//                            expiryDays: daysUntilExpiration,
//                            category: category,
//                            storage: storage
//                        )
                        let item = ShopppingItem(
                            name: itemName, exactQuantity: exactQuantity, quantityType: quantityType, notesText: ""
                        )
                        Task {
                            //await viewModel.moveSelectedToPantry(item)
                            //await viewModel.moveToPantryList(item,quantityLevel: quantityLevel, isExactQuantity: isExactQuantity, expiryDays: daysUntilExpiration, category: category, storage: storage)
                            // Dismiss both the AddNewItemView and AddItemSearch
                            dismiss()
                        }
                    } label: {
                        ButtonView(label: "Save", backgroundColor: Color("DarkGreen"), textColor: Color.white)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        ButtonView(label: "Delete", backgroundColor: .clear, textColor: Color.black)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(30)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePicker(
                "Select Expiration Date",
                selection: $customExpirationDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color("DarkGreen"))
            .accentColor(Color("DarkGreen"))
            .padding()
            .presentationDetents([.medium])
            .onChange(of: customExpirationDate) { _ in
                calculateExpirationDate()
                showDatePicker = false
            }
        }
    }
    
    private func calculateExpirationDate() {
        if expirationOption == "Custom" {
            showDatePicker = true
            daysUntilExpiration = GroceryItem.calculateExpiryDays(from: "Custom", customDate: customExpirationDate)
        } else {
            daysUntilExpiration = GroceryItem.calculateExpiryDays(from: expirationOption)
        }
    }
}

#Preview {
    MoveItemToPantryView(itemName: "test")
}
