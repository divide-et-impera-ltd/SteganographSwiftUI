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
    
    var body: some View {
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
                ISSteganographer.data(fromImage: UIImage(data: document.data)) { data, error in
                    if let error = error {
                        print(error)
                    }
                    let secretMessage = String(data: data!, encoding: String.Encoding.utf8)
                    self.decodedMessage = secretMessage!
                }
                
            }, label: {
                HStack {
                    Image(systemName: "lock.open.fill")
                    Text("Decode")
                }
            }).buttonStyle(GradientButtonStyle())
            
            Spacer().frame(height: 24)
            
            Text(decodedMessage)
                .multilineTextAlignment(TextAlignment.center)
        }
    }
}

struct DecodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        let document = Document()
        DecodeScreen(document: document)
    }
}
