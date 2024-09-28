//
//  ContentView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MarvelViewModel()

    var body: some View {
        VStack {
            if let character = viewModel.character {
                Text(character.name ?? "Unknown Character")
                    .font(.largeTitle)
                    .padding()
                
                if let description = character.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .padding()
                } else {
                    Text("No description available")
                        .font(.body)
                        .padding()
                }
                
                if let imageUrl = character.thumbnail?.fullPath, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Text("No image available")
                        .font(.caption)
                }

            } else {
                Text("Loading character...")
                    .onAppear {
                        viewModel.fetchCharacter(characterId: 1009610)
                    }
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}





