//
//  ContentView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-10.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    @State private var vm = ViewModel()
    
    var body: some View {
        if vm.isUnlocked {
            NavigationStack {
                VStack {
                    
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(vm.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            vm.selectedLocation = location
                                        }
                                }
                            }
                        }
                        .mapStyle(vm.showHybridMap ? .hybrid : .standard)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                vm.add(at: coordinate)
                            }
                        }
                        .sheet(item: $vm.selectedLocation) { location in
                            EditView(location: location) { vm.update(location: $0) }
                        }
                    }
                    .navigationTitle("BucketList")
                    .toolbar {
                        Toggle(isOn: $vm.showHybridMap) {
                            Text("Hybrid")
                        }
                    }
                }
            }
        } else {
            Button() {
                vm.authenticate()
            } label: {
                ContentUnavailableView("Login in to view your locations", systemImage: "swift")
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
