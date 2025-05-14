import SwiftUI
import PDFKit
import UniformTypeIdentifiers

class PDFGenerator {
    static func generateShoppingListPDF(items: [ShopppingItem]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Pantry App",
            kCGPDFContextAuthor: "User",
            kCGPDFContextTitle: "Shopping List"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Add title
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont
            ]
            let title = "Shopping List"
            let titleStringSize = title.size(withAttributes: titleAttributes)
            let titleStringRect = CGRect(
                x: (pageRect.width - titleStringSize.width) / 2.0,
                y: 36,
                width: titleStringSize.width,
                height: titleStringSize.height
            )
            title.draw(in: titleStringRect, withAttributes: titleAttributes)
            
            // Add date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: Date())
            let dateFont = UIFont.systemFont(ofSize: 14)
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: dateFont
            ]
            let dateStringSize = dateString.size(withAttributes: dateAttributes)
            let dateStringRect = CGRect(
                x: (pageRect.width - dateStringSize.width) / 2.0,
                y: titleStringRect.maxY + 10,
                width: dateStringSize.width,
                height: dateStringSize.height
            )
            dateString.draw(in: dateStringRect, withAttributes: dateAttributes)
            
            // Add items
            let itemFont = UIFont.systemFont(ofSize: 16)
            let itemAttributes: [NSAttributedString.Key: Any] = [
                .font: itemFont
            ]
            
            // Define column widths
            let nameColumnWidth: CGFloat = 200
            let quantityColumnWidth: CGFloat = 150
            let notesColumnWidth: CGFloat = 200
            let columnSpacing: CGFloat = 20
            
            var yPosition = dateStringRect.maxY + 30
            
            // Draw column headers
            let headerFont = UIFont.boldSystemFont(ofSize: 16)
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: headerFont
            ]
            
            "Item".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
            "Quantity".draw(at: CGPoint(x: 50 + nameColumnWidth + columnSpacing, y: yPosition), withAttributes: headerAttributes)
            "Notes".draw(at: CGPoint(x: 50 + nameColumnWidth + quantityColumnWidth + 2 * columnSpacing, y: yPosition), withAttributes: headerAttributes)
            
            yPosition += 30
            
            for item in items {
                // Item name
                let itemText = "• \(item.name)"
                let itemStringSize = itemText.size(withAttributes: itemAttributes)
                let itemStringRect = CGRect(
                    x: 50,
                    y: yPosition,
                    width: min(itemStringSize.width, nameColumnWidth),
                    height: itemStringSize.height
                )
                itemText.draw(in: itemStringRect, withAttributes: itemAttributes)
                
                // Add quantity if available
                if let quantity = item.exactQuantity, let type = item.quantityType {
                    let quantityText = "\(quantity) \(type)"
                    let quantityStringSize = quantityText.size(withAttributes: itemAttributes)
                    let quantityStringRect = CGRect(
                        x: 50 + nameColumnWidth + columnSpacing,
                        y: yPosition,
                        width: min(quantityStringSize.width, quantityColumnWidth),
                        height: quantityStringSize.height
                    )
                    quantityText.draw(in: quantityStringRect, withAttributes: itemAttributes)
                }
                
                // Add notes if available
                if !item.notesText.isEmpty {
                    let notesText = item.notesText
                    let notesStringSize = notesText.size(withAttributes: itemAttributes)
                    let notesStringRect = CGRect(
                        x: 50 + nameColumnWidth + quantityColumnWidth + 2 * columnSpacing,
                        y: yPosition,
                        width: min(notesStringSize.width, notesColumnWidth),
                        height: notesStringSize.height
                    )
                    notesText.draw(in: notesStringRect, withAttributes: itemAttributes)
                }
                
                yPosition += 25
                
                // Check if we need a new page
                if yPosition > pageRect.height - 50 {
                    context.beginPage()
                    yPosition = 50
                    
                    // Redraw headers on new page
                    "Item".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
                    "Quantity".draw(at: CGPoint(x: 50 + nameColumnWidth + columnSpacing, y: yPosition), withAttributes: headerAttributes)
                    "Notes".draw(at: CGPoint(x: 50 + nameColumnWidth + quantityColumnWidth + 2 * columnSpacing, y: yPosition), withAttributes: headerAttributes)
                    
                    yPosition += 30
                }
            }
        }
        
        return data
    }
    
    static func savePDFToTemporaryLocation(data: Data) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = "ShoppingList_\(Date().timeIntervalSince1970).pdf"
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error writing PDF to temp location: \(error)")
            return nil
        }
    }
} 
