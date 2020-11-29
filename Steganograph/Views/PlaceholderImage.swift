//
//  PlaceholderImage.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 29.11.2020.
//

import SwiftUI


struct PlaceholderImage: View {
    
    @ObservedObject var document: Document
    @State var play = 1
    
    @ViewBuilder
    var body: some View {
        if document.data.isEmpty {
            LottieView(name: "photo_animation", play: $play)
                .frame(width: 200, height: 200)
        } else {
            Image(uiImage: (UIImage(data: document.data)!))
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .clipShape(Rectangle())
                .shadow(radius: 25)
        }
    }
}


