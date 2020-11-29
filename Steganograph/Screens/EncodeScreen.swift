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
    static let hint = "Enter your secret message:"
    @State var showFilePicker = false
    @StateObject var document = Document()
    @State private var message: String = hint
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
                
                
                TextEditor(text: $message)
                    .foregroundColor(Color.gray)
                    .frame(height: 150)
                    .cornerRadius(25)
                    .shadow(radius: 5)
                    .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                    .onTapGesture {
                        if message == EncodeScreen.hint {
                            message = ""
                        }
                    }
                    
                    
                
                Button(action: {
                    // TODO check if document.data.isEmpty || message.isEmpty
                    encodeImage(data: document.data)
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
    
    func encodeImage(data: Data) {
        showProgressView = true
        ISSteganographer.hideData(message, withImage: UIImage(data: data)) { image, error in
            if let error = error {
                print(error)
                showProgressView = false
            }
            let img = image as! UIImage

            let filename = URL(string: documentUrl)?.appendingPathComponent("\(randomString(length: 12)).png")
            try? img.pngData()!.write(to: filename!)
            DispatchQueue.main.async {
                document.data = Data()
            }
            message = ""
            showProgressView = false

        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let document = Document()
        return EncodeScreen(document: document)
    }
}
