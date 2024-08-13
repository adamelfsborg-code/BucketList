//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-13.
//

import Foundation

extension EditView {
@Observable
    class ViewModel {
        enum LoadingState {
            case loading, loaded, failed
        }
        var loadingState: LoadingState = .loading
        
        var location: Location
        var name: String
        var description: String
        
        private(set) var pages = [Page]()
        
        init(location: Location) {
            self.location = location
            
            name = location.name
            description = location.description
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
}
