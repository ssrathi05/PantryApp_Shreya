//
//  MoreView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/19/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct MoreView: View {
    @EnvironmentObject var viewModel: PantryListViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isShowing: Bool
    @State private var showShareSheet = false
    @State private var pdfURL: URL?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Spacer()
                .frame(height: 15)
            Button {
                isShowing = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 23))
                    .foregroundStyle(.black)
            }
            
            Button {
                generateAndSharePDF()
            } label: {
                Text("Share list")
                    .font(.system(size: 17))
            }
            
            Button {
                viewModel.selectAll()
            } label: {
                Text("Select all")
                    .font(.system(size: 17))
            }
            
            Button {
                viewModel.unselectAll()
            } label: {
                Text("Unselect all")
                    .font(.system(size: 17))
            }
            
            Button {
                Task {
                    await viewModel.deleteSelectedItems()
                }
            } label: {
                Text("Delete")
                    .font(.system(size: 17))
                    .foregroundStyle(.red)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.black)
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ShareSheet1(activityItems: [url])
                    .presentationDetents([.fraction(0.60)])
                    .presentationCornerRadius(45)
                    .onDisappear {
                        cleanupPDF()
                    }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func generateAndSharePDF() {
        guard !viewModel.shoppingItems.isEmpty else {
            errorMessage = "No items to share"
            showError = true
            return
        }
        
        if let pdfData = PDFGenerator.generateShoppingListPDF(items: viewModel.shoppingItems),
           let url = PDFGenerator.savePDFToTemporaryLocation(data: pdfData) {
            self.pdfURL = url
            showShareSheet = true
        } else {
            errorMessage = "Failed to generate PDF"
            showError = true
        }
    }
    
    private func cleanupPDF() {
        if let url = pdfURL {
            try? FileManager.default.removeItem(at: url)
            pdfURL = nil
        }
    }
}

struct ShareSheet1: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        
        // Configure the share sheet
        controller.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks,
            .markupAsPDF
        ]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    MoreView(isShowing: .constant(true))
        .environmentObject(PantryListViewModel())
}
