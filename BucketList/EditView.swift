//
//  EditView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-11.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
   
    @State private var vm: ViewModel
    
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location", text: $vm.name)
                    TextField("Description", text: $vm.description)
                }
                
                Section("Nearby...") {
                    switch(vm.loadingState) {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(vm.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Something went wrong...")
                    }
                }
            }
            .navigationTitle("Location detials")
            .toolbar {
                Button("Save") {
                    var newLocation = vm.location
                   
                    newLocation.id = UUID()
                    newLocation.name = vm.name
                    newLocation.description = vm.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await vm.fetchNearbyLocations()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _vm = State(initialValue: ViewModel(location: location))
    }
}

#Preview {
    EditView(location: .example) { location in
        print(location.name)
    }
}
