//
//  ContentView.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import ISStego


struct EncodeScreen: View {
    
    @State var showFilePicker = false
    @StateObject var document = Document()
    @State private var message: String = ""
    @State private var documentUrl: String = ""
    @State private var showProgressView: Bool = false
    
   
    
    var body: some View {
        
        ZStack {
            VStack {
                Button (action: {
                    self.showFilePicker.toggle()
                }) {
                    PlaceholderImage(document: document)
                }
                .sheet(isPresented: $showFilePicker) {
                    DocumentPicker(callback: { url in
                        do {
                            document.data = try Data(contentsOf: url)
                            print(url.deletingLastPathComponent())
                            documentUrl = url.deletingLastPathComponent().absoluteString
                        } catch {
                            print(error)
                        }
                        
                    }, onDismiss: { self.showFilePicker = false })
                }
                Spacer().frame(height: 24)
                TextField("Enter your secret message", text: $message)
                    .multilineTextAlignment(TextAlignment.center)
                Spacer().frame(height: 24)
                Button(action: {
                    showProgressView = true
                    ISSteganographer.hideData(message, withImage: UIImage(data: document.data)) { image, error in
                        if let error = error {
                            print(error)
                            showProgressView = false
                        }
                        let img = image as! UIImage
                        DispatchQueue.main.async {
                            document.data = img.pngData()!
                            
                        }
                        let filename = URL(string: documentUrl)?.appendingPathComponent("\(randomString(length: 12)).png")
                        try? img.pngData()!.write(to: filename!)
                        showProgressView = false
                    }
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Encode")
                    }
                }.buttonStyle(GradientButtonStyle())
            }
            
            if showProgressView {
                ProgressView("Encoding...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let document = Document()
        return EncodeScreen(document: document)
    }
}
