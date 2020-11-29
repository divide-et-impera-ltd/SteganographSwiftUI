//
//  AppView.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI

struct AppView: View {
    
    @StateObject var document = Document()
    
    var body: some View {
        TabView {
            EncodeScreen(document: document)
                .tabItem {
                    Image(systemName: "lock.fill")
                    Text("Encode")
                }
            DecodeScreen(document: document)
                .tabItem {
                    Image(systemName: "lock.open.fill")
                    Text("Decode")
                }

        }.accentColor(.orange)
    }
}
