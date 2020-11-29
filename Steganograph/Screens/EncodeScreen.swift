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
    @ObservedObject var document: Document
    @State private var message: String = ""
    @State private var documentUrl: String = ""
    
    var body: some View {
       
        VStack {
            Button (action: {
                self.showFilePicker.toggle()
            }) {
                Image(uiImage: (UIImage(data: document.data) ?? UIImage(systemName: "square.and.arrow.down"))!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 20)
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
                ISSteganographer.hideData(message, withImage: UIImage(data: document.data)) { image, error in
                    if let error = error {
                        print(error)
                    }
                    let img = image as! UIImage
                    DispatchQueue.main.async {
                        document.data = img.pngData()!
                        
                    }
                    let filename = URL(string: documentUrl)?.appendingPathComponent("steganograped.png")
                    try? img.pngData()!.write(to: filename!)
                   
                }
            }) {
                Image(systemName: "lock.fill")
                Text("Encode")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let document = Document()
        return EncodeScreen(document: document)
    }
}
