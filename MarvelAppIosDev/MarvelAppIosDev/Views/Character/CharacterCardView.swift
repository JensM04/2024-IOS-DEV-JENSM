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
                GeometryReader { geometry in
                    let size = min(geometry.size.width, geometry.size.height)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    if let url = imageUrl, let validUrl = URL(string: url) {
                        AsyncImage(url: validUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: size, height: size)
                                .cornerRadius(8)
                        } placeholder: {
                            ZStack {
                                Color.gray.opacity(0.1)
                                    .cornerRadius(8)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                    .scaleEffect(1.5)
                                    .foregroundColor(.red)
                            }
                            .frame(width: size, height: size)
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill.badge.xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size * 0.5, height: size * 0.5)
                            .foregroundColor(.gray)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
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

#Preview {
    CharacterCardView(
        name: "3-D Man",
        imageUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
    )
}
