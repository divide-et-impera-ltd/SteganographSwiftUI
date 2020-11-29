//
//  AppView.swift
//  Steganograph
//
//  Created by Razvan Rujoiu on 28.11.2020.
//

import SwiftUI

struct AppView: View {
    
    var body: some View {
        TabView {
            EncodeScreen()
                .tabItem {
                    Image(systemName: "lock.fill")
                    Text("Encode")
                }
            DecodeScreen()
                .tabItem {
                    Image(systemName: "lock.open.fill")
                    Text("Decode")
                }

        }.accentColor(.orange)
    }
}
