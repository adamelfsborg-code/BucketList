//
//  EditView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-11.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
   
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState: LoadingState = .loading
    @State private var pages = [Page]()
    
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch(loadingState) {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
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
                    var newLocation = location
                   
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyLocations()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    func fetchNearbyLocations() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            loadingState = .failed
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            print("Failed to fetch nearby locations: \(error.localizedDescription)")
            loadingState = .failed
        }
        
    }
}

#Preview {
    EditView(location: .example) { location in
        print(location.name)
    }
}
