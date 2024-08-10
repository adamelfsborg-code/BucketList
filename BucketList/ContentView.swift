//
//  ContentView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-10.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("loading")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("success")
    }
}
struct FailedView: View {
    var body: some View {
        Text("failed")
    }
}

struct ContentView: View {
    enum LoadingState {
        case loading, success, failed
    }
    
    @State private var loadingState: LoadingState = .loading
    
    var body: some View {
        switch(loadingState) {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

#Preview {
    ContentView()
}
