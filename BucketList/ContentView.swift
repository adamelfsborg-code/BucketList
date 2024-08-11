//
//  ContentView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-10.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        MapReader { proxy in
            Map()
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
