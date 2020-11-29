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
    @State private var decodedMessage: String = ""
    @State private var showProgressView = false
    
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
                        // TODO display alert to prompt user to drop image
                    }
                    decodeImage(data: document.data)
                }) {
                    HStack {
                        Image(systemName: "lock.open.fill")
                        Text("Decode")
                    }
                }.buttonStyle(GradientButtonStyle())
                
                Spacer().frame(height: 24)
                
                VStack {
                    if !decodedMessage.isEmpty {
                    TextEditor(text: $decodedMessage)
                        .foregroundColor(.gray)
                        .cornerRadius(25)
                        .frame(height: 150)
                        .shadow(radius: 5)
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 24, trailing: 24))
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
            let secretMessage = String(data: data!, encoding: String.Encoding.utf8)
            self.decodedMessage = secretMessage!
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
