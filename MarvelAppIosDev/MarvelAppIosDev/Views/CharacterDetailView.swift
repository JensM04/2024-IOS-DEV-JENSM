//
//  CharacterDetailView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 02/01/2025.
//


import SwiftUI

struct CharacterDetailView: View {
    let characterName: String

    var body: some View {
        VStack {
            Text(characterName)
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Character")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CharacterDetailView(characterName: "Spider-Man")
}
