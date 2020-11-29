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
    
    var body: some View {
        HStack {
            if document.data.isEmpty {
                LottieView(name: "photo_animation", play: $play)
                    .frame(width: 150, height: 150)
            } else {
                Image(uiImage: (UIImage(data: document.data)!))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 20)
            }
        }
    }
}


