//
//  ContentView.swift
//  SmartShop
//
//  Created by 안재원 on 5/20/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.authenticationController) private var authenticationController
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
