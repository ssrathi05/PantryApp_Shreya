import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    @State private var isScanning = false
    @State private var scannedCode: String?
    @State private var productName: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showAddView = false
    @State private var cameraSession: CameraSession?
    
    @State var isShopping = false
    
    var body: some View {
        ZStack {
            // Camera preview
            if let session = cameraSession {
                CameraPreviewView(cameraSession: session, isScanning: $isScanning, scannedCode: $scannedCode)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // Overlay with scanning box
            VStack {
                Spacer()
                    .frame(height: 20)
                HStack {
                    Spacer()
                        .frame(width: 20)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    Spacer()
                }
                Spacer()
                
                // Scanning box
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 250, height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                    )
                
                Spacer()
                
                // Status text
                if let productName = productName {
                    Button {
                        // Stop scanning and clean up
                        isScanning = false
                        scannedCode = nil
                        
                        // Small delay to ensure camera cleanup
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showAddView = true
                        }
                    } label: {
                        Text("Add " + productName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                    }
                }
                
                // Close button
                Button {
                    isScanning = false
                    scannedCode = nil
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .alert("Scan Result", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .onChange(of: scannedCode) { newValue in
            if let code = newValue {
                fetchProductInfo(barcode: code)
            }
        }
        .sheet(isPresented: $showAddView) {
            if isShopping {
                ShoppingAddNewItemView(itemName: productName ?? "")
                    .presentationCornerRadius(25)
            } else {
                AddNewItemView(itemName: productName ?? "")
                    .presentationCornerRadius(25)
            }
        }
        .onAppear {
            // Reset state when view appears
            productName = nil
            scannedCode = nil
            cameraSession = CameraSession()
            cameraSession?.configure()
            isScanning = true
        }
        .onDisappear {
            // Clean up when view disappears
            isScanning = false
            scannedCode = nil
            productName = nil
            cameraSession?.stop()
            cameraSession = nil
        }
    }
    
    private func fetchProductInfo(barcode: String) {
        // Using Open Food Facts API
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let product = json["product"] as? [String: Any],
                       let name = product["product_name"] as? String {
                        DispatchQueue.main.async {
                            self.productName = name
                            self.alertMessage = "Found: \(name)"
                            self.showAlert = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertMessage = "Product not found"
                            self.showAlert = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Error processing product data"
                        self.showAlert = true
                    }
                }
            }
        }.resume()
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let cameraSession: CameraSession
    @Binding var isScanning: Bool
    @Binding var scannedCode: String?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.isUserInteractionEnabled = false
        
        // Setup preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession.session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Set delegate
        if let output = cameraSession.session.outputs.first as? AVCaptureMetadataOutput {
            output.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isScanning {
            cameraSession.start()
        } else {
            cameraSession.stop()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CameraPreviewView
        
        init(_ parent: CameraPreviewView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let code = metadataObject.stringValue else { return }
            
            // Prevent multiple scans
            output.metadataObjectTypes = [] // Disable further scanning
            
            DispatchQueue.main.async {
                self.parent.scannedCode = code
            }
        }
    }
}

class CameraSession {
    let session = AVCaptureSession()
    var isConfigured = false
    
    func configure() {
        guard !isConfigured else { return }
        
        // Setup camera session
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [.ean8, .ean13, .upce]
        }
        
        session.commitConfiguration()
        isConfigured = true
    }
    
    func start() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
}
