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

    @StateObject var document = Document()
    @StateObject var secretMessage = SecretMessage(hint)
    
    @State var documentUrl: String = ""
    @State var showProgressView: Bool = false
    @State var showFilePicker = false
    @State var showEmptyFieldsAlert = false
    
    
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
                            url.startAccessingSecurityScopedResource()
                            document.data = try Data(contentsOf: url)
                            print(url.deletingLastPathComponent().path)
                            documentUrl = url.deletingLastPathComponent().relativePath
                        } catch {
                            print(error)
                        }
                        
                    }, onDismiss: { self.showFilePicker = false })
                }
                
                
                CustomTextEditor(secretMessage: secretMessage)
                    
                
                Button(action: {
                    
                    if document.data.isEmpty || secretMessage.message == EncodeScreen.hint || secretMessage.message.isEmpty {
                        self.showEmptyFieldsAlert = true
                        return
                    }
                    encodeImage(data: document.data)
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Encode")
                    }
                }.buttonStyle(GradientButtonStyle())
                .alert(isPresented: $showEmptyFieldsAlert, content: {
                    Alert(title: Text("Error"),
                          message: Text("Please upload a file and input a secret message"),
                          dismissButton: .default(Text("Ok")))
                })
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
        ISSteganographer.hideData(secretMessage.message, withImage: UIImage(data: data)) { image, error in
            if let error = error {
                print(error)
                showProgressView = false
            }
            let img = image as! UIImage
            let url = URL(fileURLWithPath: documentUrl)
            
            let filename = URL(fileURLWithPath: "\(randomString(length: 12)).png", relativeTo: url)
            
            filename.startAccessingSecurityScopedResource()
            
            do {
               
                try img.pngData()!.write(to: filename)
            } catch {
                print(error)
            }
           
            DispatchQueue.main.async {
                document.data = Data()
                secretMessage.message = ""
            }
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
