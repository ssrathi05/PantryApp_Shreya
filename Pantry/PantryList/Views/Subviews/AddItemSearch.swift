//
//  AddItemSearch.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/15/25.
//

import SwiftUI

struct AddItemSearch: View {
    @State var addsearch: String = ""
    @State var showAddItem = false
    @State var showBarcode = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PantryListViewModel
    
    var isShopping: Bool = false

    var body: some View {
        NavigationStack{
            ZStack{
               
                VStack{
                    Spacer()
                        .frame(height: 25)
                    
                    HStack(alignment: .center){
                        Spacer()
                            .frame(width: 30)
                        Button{
                            dismiss()
                        }label:{
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                
                        }
                        Spacer()
                            .frame(width: 120)
                        Text("Add Item")
                        Spacer()
                    }
                        
                    
                    //search bar
                    HStack{
                        ZStack{
                            TextField("Search items...", text: $addsearch)
                                .padding(20)
                                .font(.system(size: 15))
                                .frame(height: 40)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 0.5)
                                )
                                .cornerRadius(20)
                           
                            HStack{
                                Spacer()
                                if(addsearch !=  ""){
                                    NavigationLink {
                                        if isShopping{
                                            ShoppingAddNewItemView(itemName: addsearch)
                                                .navigationBarBackButtonHidden()
                                        }else{
                                            AddNewItemView(itemName: addsearch)
                                                .navigationBarBackButtonHidden()
                                        }
                                        
                                    } label: {
                                        Text("ADD")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                            .padding()
                                    }
                                }
                            }
                        }
                        
                        NavigationLink {
                            BarcodeScannerView(isShopping: isShopping)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "barcode.viewfinder")
                                .font(.system(size: 25))
                                .foregroundStyle(Color("DarkGreen"))
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    //recently added
                    ZStack{
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(20)
                        VStack(alignment: .leading, spacing: 10){
                            HStack{
                                if isShopping{
                                    Text("BUY AGAIN")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                }else{
                                    Text("RECENTLY ADDED")
                                        .font(.system(size: 13))
                                        .fontWeight(.semibold)
                                }
                                
                                    
                                Spacer()
                            }
                            
                            if isShopping{
                                if viewModel.buyAgainItems.isEmpty {
                                    Text("No recently bought items")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                        .padding(.top, 10)
                                } else {
                                    ForEach(viewModel.buyAgainItems, id: \.id) { item in
                                        HStack {
                                            Text(item.name)
                                                .font(.system(size: 17))
                                            Spacer()
                                            Button {
                                                Task {
                                                    await viewModel.addShoppingItem(item)
                                                }
                                            } label: {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundStyle(Color("DarkGreen"))
                                                    .font(.system(size: 24))
                                            }
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                            }else{
                                if viewModel.recentlyAddedItems.isEmpty {
                                    Text("No recently added items")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                        .padding(.top, 10)
                                } else {
                                    ForEach(viewModel.recentlyAddedItems, id: \.id) { item in
                                        HStack {
                                            Text(item.name)
                                                .font(.system(size: 17))
                                            Spacer()
                                            Button {
                                                Task {
                                                    await viewModel.addItem(item)
                                                }
                                            } label: {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundStyle(Color("DarkGreen"))
                                                    .font(.system(size: 24))
                                            }
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
            }
            .background(.white)
        }
        
        
        
    }
}

#Preview {
    AddItemSearch()
        .environmentObject(PantryListViewModel())
}
