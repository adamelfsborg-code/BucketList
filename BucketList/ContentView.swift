//
//  ContentView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-10.
//

import SwiftUI

struct User: Identifiable, Comparable {
    let id = UUID()
    var firstName: String
    var lastName: String
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName && lhs.firstName < rhs.firstName
    }
}

struct ContentView: View {
    let users = [
        User(firstName: "Ragnar", lastName: "Lodbrok"),
        User(firstName: "Floki", lastName: "Vilgerdsson"),
        User(firstName: "Athelstan", lastName: "King of Kings"),
    ].sorted()
    
    var body: some View {
        List(users) {
            Text("\($0.lastName), \($0.firstName)")
        }
    }
}

#Preview {
    ContentView()
}
