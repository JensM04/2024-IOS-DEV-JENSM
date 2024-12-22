//
//  CharacterCardView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 22/12/2024.
//

import SwiftUI

struct CharacterCardView: View {
    let name: String
    let imageUrl: String?

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 150, height: 150)
                    .cornerRadius(8)

                if let url = imageUrl, let validUrl = URL(string: url) {
                    AsyncImage(url: validUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill.badge.xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50) 
                        .foregroundColor(.gray)
                }
            }

            Text(name.isEmpty ? "Unknown Character" : name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

