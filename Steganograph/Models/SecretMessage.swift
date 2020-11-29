//
//  SecretMessage.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 30.11.2020.
//

import Foundation

class SecretMessage: ObservableObject {
    @Published var message = ""
    
    init (_ message: String) {
        self.message = message
    }
}
