//
//  CustomTextEditor.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 30.11.2020.
//

import SwiftUI

struct CustomTextEditor: View {
    
    @ObservedObject var secretMessage: SecretMessage
    
    var body: some View {
        TextEditor(text: $secretMessage.message)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.leading)
            .frame(height: 150)
            .cornerRadius(25)
            .shadow(radius: 5)
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .onTapGesture {
                if secretMessage.message == EncodeScreen.hint {
                    secretMessage.message = ""
                }
            }
    }
}

