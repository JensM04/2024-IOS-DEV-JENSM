//
//  CharacterDetailView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import Foundation
import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack {
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
        }
        .padding()
    }
}
