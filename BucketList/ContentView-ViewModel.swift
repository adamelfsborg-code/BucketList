//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-12.
//
import CoreLocation
import MapKit
import Foundation
import LocalAuthentication
import _MapKit_SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        private(set) var mapStyles: [MapStyle] = [.hybrid, .standard]
        
        var selectedLocation: Location?
        var showHybridMap = false
        
        var isUnlocked = false
        let savePath = URL.documentsDirectory.appending(path: "SavedLocations")
        
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
            
        }
        
        
        func add(at point: CLLocationCoordinate2D) -> Void {
            let location = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(location)
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error saving locations: \(error.localizedDescription)")
            }
        }
        
        func update(location: Location) -> Void {
            guard let selectedLocation else {return}
            
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your locations"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        
                    }
                }
            } else {
                
            }
        }
    }
}
