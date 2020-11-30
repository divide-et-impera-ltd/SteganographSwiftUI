//
//  Document.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 29.11.2020.
//

import Foundation
import SwiftUI

class Document: ObservableObject {
    
    @Published var data = Data()
    @Published var encodedImage = UIImage()
    
}
