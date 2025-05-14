//
//  AddNewItemView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/18/25.
//

import SwiftUI

struct AddNewItemView: View {
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
               
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                                
                        }
                        Spacer()
                    }
                    Text(itemName)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold))
                        .underline()
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
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
                        let item = GroceryItem(
                            name: itemName,
                            exactQuantity: exactQuantity,
                            quantityType: quantityType,
                            quantityLevel: quantityLevel,
                            isExactQuantity: isExactQuantity,
                            expiryDays: daysUntilExpiration,
                            category: category,
                            storage: storage
                        )
                        Task {
                            await viewModel.addItem(item)
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

// Preview that demonstrates the sheet presentation
struct AddNewItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItemView(itemName: "test")
    }
}



struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .fill(configuration.isOn ? Color("DarkGreen") : Color("LightGreen"))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        configuration.isOn.toggle()
                    }
                }
        }
        .padding()
    }
}

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    var items: Data
    var spacing: CGFloat
    var content: (Data.Element) -> Content

    @State private var totalWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            self.createWrappedLayout(availableWidth: geometry.size.width)
        }
    }

    private func createWrappedLayout(availableWidth: CGFloat) -> some View {
        var width: CGFloat = 0
        var rows: [[Data.Element]] = [[]]

        for item in items {
            let itemWidth = estimateItemWidth(item)
            
            if width + itemWidth + spacing > availableWidth {
                rows.append([item])
                width = itemWidth
            } else {
                rows[rows.count - 1].append(item)
                width += itemWidth + spacing
            }
        }

        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: spacing) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, item in
                        content(item)
                    }
                }
            }
        }
    }

    private func estimateItemWidth(_ item: Data.Element) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17) // Default SwiftUI font size
        let attributes = [NSAttributedString.Key.font: font]
        let size = (String(describing: item) as NSString).size(withAttributes: attributes)
        return size.width + 20 // Account for padding
    }
}


