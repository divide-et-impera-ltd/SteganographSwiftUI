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
    @ObservedObject var document: Document
    @State private var decodedMessage: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                self.showFilePicker.toggle()
            }, label: {
                Image(uiImage: (UIImage(data: document.data) ?? UIImage(systemName: "square.and.arrow.down"))!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
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
           Text(decodedMessage)
            
            Button(action: {
                
                ISSteganographer.data(fromImage: UIImage(data: document.data)) { data, error in
                    if let error = error {
                        print(error)
                    }
                    let secretMessage = String(data: data!, encoding: String.Encoding.utf8)
                    self.decodedMessage = secretMessage!
                }
                
            }, label: {
                Text("Decode")
            })
        }
    }
}

struct DecodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        let document = Document()
        DecodeScreen(document: document)
    }
}
