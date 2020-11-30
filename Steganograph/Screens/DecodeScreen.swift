//
//  DecodeScreen.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI
import ISStego

struct DecodeScreen: View {
    
    @State var showFilePicker = false
    @StateObject var document = Document()
    @StateObject var decodedMessage = SecretMessage("")
    @State private var showProgressView = false
    @State var showEmptyFieldsAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    self.showFilePicker.toggle()
                }, label: {
                    PlaceholderImage(document: document)
                }).sheet(isPresented: $showFilePicker, content: {
                    DocumentPicker(callback: { url in
                        do {
                            url.startAccessingSecurityScopedResource()
                            document.data = try Data(contentsOf: url)
                            print(url.deletingLastPathComponent())
                        } catch {
                            print(error)
                        }
                        
                    }, onDismiss: { self.showFilePicker = false })
                })
                
                Spacer().frame(height: 24)
                
                Button(action: {
                    if document.data.isEmpty {
                        self.showEmptyFieldsAlert = true
                        return
                    }
                    decodeImage(data: document.data)
                }) {
                    HStack {
                        Image(systemName: "lock.open.fill")
                        Text("Decode")
                    }
                }
                .buttonStyle(GradientButtonStyle())
                .alert(isPresented: $showEmptyFieldsAlert, content: {
                    Alert(title: Text("Error"),
                          message: Text("Please upload a file to decode"),
                          dismissButton: .default(Text("Ok")))
                })
                
                
                VStack {
                    if !decodedMessage.message.isEmpty {
                        CustomTextEditor(secretMessage: decodedMessage)
                    }
                }
            }
            if showProgressView == true {
                ProgressView("Decoding...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
    
    func decodeImage(data: Data) {
        showProgressView = true
        ISSteganographer.data(fromImage: UIImage(data: data)) { data, error in
            if let error = error {
                print(error)
                showProgressView = false
            }
            self.decodedMessage.message = String(data: data!, encoding: String.Encoding.utf8)!
            showProgressView = false
        }
    }
}

struct DecodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        let document = Document()
        DecodeScreen(document: document)
    }
}
