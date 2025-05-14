//
//  ShoppingAddItemView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct ShoppingAddNewItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var itemName: String
    @State var exactQuantity: Int = 1
    @State var quantityType: String = "Bag(s)"
    
    @State var category: String = "Fruits"
    @State var storage: String = "Fridge"
    @State var expirationOption: String = "1 week"
    @State var customExpirationDate: Date = Date()
    @State var showDatePicker: Bool = false
    @State var daysUntilExpiration: Int = 7
    @State var notesText: String = ""
    
    let quantityTypes = ["Bag(s)", "Bottle(s)", "Box(es)", "Jar(s)", "Bundle(s)","+7"]
    
    @EnvironmentObject var viewModel: PantryListViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    // Back button at the top
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                
                        }
                        Spacer()
                    }
                    
                    
                    // Item name
                    Text(itemName)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold))
                        .underline()
                        .frame(maxWidth: 250)
                        .padding(.vertical)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    
                    // Quantity section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("QUANTITY")
                            .font(.system(size: 13, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 17) {
                            NumberStepper(quantity: $exactQuantity)
                            
                            OptionPicker(
                                selectedOption: $quantityType,
                                options: quantityTypes,
                                spacing: 14,
                                height: 100
                            )
                        }
                    }
                    
                    Spacer()
                        .frame(height: 15)
                    
                    // Notes section
                    HStack{
                        Text("NOTES")
                            .font(.system(size: 13, weight: .bold))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 15)
                    
                    TextEditor(text: $notesText)
                            .frame(height: 150) // Adjust height as needed
                            .padding(8)
                            
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    
                    
                    Spacer(minLength: 20)
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button {
                            let item = ShopppingItem(
                                name: itemName,
                                exactQuantity: exactQuantity,
                                quantityType: quantityType,
                                notesText: notesText
                                
                            )
                            Task {
                                await viewModel.addShoppingItem(item)
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
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ShoppingAddNewItemView(itemName: "celcius sparking water flavore")
        .environmentObject(PantryListViewModel())
}
