//
//  ContentView.swift
//  BucketList
//
//  Created by Adam Elfsborg on 2024-08-10.
//

import SwiftUI

extension FileManager {
    func write(path: String, data: Data) throws -> Void {
        let url = URL.documentsDirectory.appending(path: path)
        try data.write(to: url, options: [.atomic, .completeFileProtection])
    }
    
    func read(path: String) throws -> String {
        let url = URL.documentsDirectory.appending(path: path)
        return try String(contentsOf: url)
    }
}

struct ContentView: View {

    var body: some View {
        Button("Read and write") {
            let fileManger = FileManager.default
            let data = Data("Test messgae".utf8)
           
            do {
                try fileManger.write(path: "message.txt", data: data)
                let input = try fileManger.read(path: "message.txt")
                print(input)
            } catch {
                print("Failed to write message to file: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
