//
//  ContentView.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

struct EncodeScreen: View {
    
    @State var showFilePicker = false
    @ObservedObject var document: Document
    
    func parseFile(_ url: URL) {
        print(url.absoluteURL)
    }
    
    var body: some View {
       
        VStack {
            Button (action: {
                self.showFilePicker.toggle()
            }) {
                Image(uiImage: (UIImage(data: document.data) ?? UIImage(systemName: "square.and.arrow.down"))!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPicker(callback: { url in
                    do {
                        document.data = try Data(contentsOf: url)
                        print(url)
                    } catch {
                        print(error)
                    }
                   
                }, onDismiss: { self.showFilePicker = false })
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        func filePicked(_ url: URL) {
//            print("Filename: \(url)")
        }
        let document = Document()
        return EncodeScreen(document: document)
    }
}
