//
//  DecodeScreen.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI

struct DecodeScreen: View {
    
    @ObservedObject var document: Document
    
    var body: some View {
        VStack {
            Image(uiImage: (UIImage(data: document.data) ?? UIImage(systemName: "square.and.arrow.down"))!)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

struct DecodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        let document = Document()
        DecodeScreen(document: document)
    }
}
