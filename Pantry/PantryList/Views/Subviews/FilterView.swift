//
//  FilterView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/15/25.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var sortChoice: String
    @Binding var filterChoice: String
    @Binding var listChoices: Set<String>
    
    // Add temporary state variables
    @State private var tempSortChoice: String
    @State private var tempFilterChoice: String
    @State private var tempListChoices: Set<String>
    
    let sortOptions = ["Category", "Expiry Date"]
    let filterOptions = ["Fruits", "Vegetables","Meat","Seafood","Dairy","Beverages","Sweets","Condiments"]
    
    init(sortChoice: Binding<String>, filterChoice: Binding<String>, listChoices: Binding<Set<String>>) {
        self._sortChoice = sortChoice
        self._filterChoice = filterChoice
        self._listChoices = listChoices
        
        // Initialize temporary state with current values
        self._tempSortChoice = State(initialValue: sortChoice.wrappedValue)
        self._tempFilterChoice = State(initialValue: filterChoice.wrappedValue)
        self._tempListChoices = State(initialValue: listChoices.wrappedValue)
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .semibold))
                    }
                    Spacer()
                    Button{
                        // Reset temporary values
                        tempSortChoice = "Category"
                        tempFilterChoice = ""
                        tempListChoices = ["Pantry", "Fridge", "Freezer"]
                    } label: {
                        Text("Clear selections")
                            .foregroundColor(.black)
                            .font(.system(size: 17))
                            .underline()
                    }
                
                }
                .padding(.vertical)
                Text("Sort by")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                //options picker
                OptionPicker(selectedOption: $tempSortChoice, options: sortOptions, spacing: 14, height:50)
                
                Text("Filter")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                Text("See groceries categorized as:")
                    .font(.system(size: 17))
                OptionPicker(selectedOption: $tempFilterChoice, options: filterOptions, spacing: 14, height: 170)
                
                Text("See groceries stored in:")
                    .font(.system(size: 17))
                
                HStack(spacing: 38){
                    ForEach(["Pantry", "Fridge", "Freezer"], id: \.self) { location in
                        Button {
                            if tempListChoices.contains(location) {
                                tempListChoices.remove(location)
                            } else {
                                tempListChoices.insert(location)
                            }
                        } label: {
                            Text(location)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(tempListChoices.contains(location) ? Color("DarkGreen") : Color("LightGreen"))
                                .foregroundStyle(tempListChoices.contains(location) ? .white : .black)
                                .fontWeight(.regular)
                                .cornerRadius(20)
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 30)
                
                HStack{
                    Spacer()
                    Button{
                        // Apply the temporary values to the bindings
                        sortChoice = tempSortChoice
                        filterChoice = tempFilterChoice
                        listChoices = tempListChoices
                        dismiss()
                    }label:{
                        Text("Apply")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 25)
                            .background(Color("DarkGreen"))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .cornerRadius(20)
                    }
                    Spacer()
                }
            }
        }
        
        .padding(.horizontal, 30)
    }
}

#Preview {
    FilterView(
        sortChoice: .constant("Category"),
        filterChoice: .constant(""),
        listChoices: .constant(["Pantry", "Fridge", "Freezer"])
    )
}
