//
//  CharacterDetailView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 02/01/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    @ObservedObject var viewModel: MarvelViewModel
    let character: Character
    @Environment(\.presentationMode) var presentationMode
    
    init(character: Character, viewModel: MarvelViewModel) {
        self.character = character
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let fullPath = character.thumbnail?.fullPath,
                   let url = URL(string: fullPath) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    } placeholder: {
                        ProgressView()
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.2))
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            Text("No image available")
                                .foregroundColor(.gray)
                        )
                }
                
                //beschrijving
                VStack(alignment: .leading, spacing: 16) {
                    Text("About")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                    
                    if let description = character.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .lineSpacing(4)
                    } else {
                        Text("No description available.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Text("Explore More")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.top)
                    
                    //buttons
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        NavigationButton(title: "Comics", icon: "book.fill") {
                            ComicListView(viewModel: viewModel)
                                .onAppear {
                                    viewModel.fetchComics(characterId: character.id ?? 0)
                                }
                        }
                        
                        NavigationButton(title: "Events", icon: "star.fill") {
                            Text("Events Page")
                        }
                        
                        NavigationButton(title: "Series", icon: "rectangle.stack.fill") {
                            Text("Series Page")
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
            }
        }
        .navigationTitle(character.name ?? "Unknown Character")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(uiColor: .systemBackground))
    }
}

//navigatie met animatie
struct NavigationButton<Destination: View>: View {
    let title: String
    let icon: String
    let destination: Destination
    
    init(title: String, icon: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.icon = icon
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.callout)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red)
                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .foregroundColor(.white)
        }
    }
}
