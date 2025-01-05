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
    @Environment(\.horizontalSizeClass) var sizeClass
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
                            .frame(height: sizeClass == .regular ? 400 : 300)
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
                            .frame(height: sizeClass == .regular ? 400 : 300)
                            .background(Color.gray.opacity(0.2))
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: sizeClass == .regular ? 400 : 300)
                        .overlay(
                            Text("No image available")
                                .foregroundColor(.gray)
                        )
                }
                
                //beschrijving
                VStack(alignment: .leading, spacing: sizeClass == .regular ? 24 : 16) {
                    Text("About")
                        .font(sizeClass == .regular ? .title.bold() : .title2.bold())
                        .foregroundColor(.red)
                    
                    if let description = character.description, !description.isEmpty {
                        Text(description)
                            .font(sizeClass == .regular ? .title3 : .body)
                            .lineSpacing(sizeClass == .regular ? 6 : 4)
                            .foregroundColor(.primary)
                    } else {
                        Text("No description available.")
                            .font(sizeClass == .regular ? .title3 : .body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, sizeClass == .regular ? 32 : 16)
                
                VStack(spacing: sizeClass == .regular ? 24 : 16) {
                    Text("Explore More")
                        .font(sizeClass == .regular ? .title2.bold() : .title3.bold())
                        .foregroundColor(.red)
                    
                    //buttons
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: sizeClass == .regular ? 20 : 12) {
                        NavigationButton(title: "Comics", icon: "book.fill", isIPad: sizeClass == .regular) {
                            ComicListView(viewModel: viewModel, isForAllComics: false)
                                .onAppear {
                                    viewModel.fetchComics(characterId: character.id ?? 0)
                                }
                        }
                        
                        NavigationButton(title: "Events", icon: "star.fill", isIPad: sizeClass == .regular) {
                            EventListView(viewModel: viewModel)
                                .onAppear {
                                    viewModel.fetchEvents(characterId: character.id ?? 0)
                                }
                        }
                        
                        NavigationButton(title: "Series", icon: "rectangle.stack.fill", isIPad: sizeClass == .regular) {
                            SeriesListView(viewModel: viewModel, characterId: character.id ?? 0)
                                .onAppear {
                                    viewModel.fetchEvents(characterId: character.id ?? 0)
                                }
                        }
                    }
                    .padding(.horizontal, sizeClass == .regular ? 16 : 0)
                    
                    //listbutton
                    Button(action: {
                        viewModel.showListSelection = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(sizeClass == .regular ? .large : .medium)
                            Text("Add to List")
                                .font(sizeClass == .regular ? .title3.bold() : .body.bold())
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: sizeClass == .regular ? 18 : 14, weight: .semibold))
                                .opacity(0.7)
                        }
                        .padding(sizeClass == .regular ? 20 : 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.red)
                                .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
                        )
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, sizeClass == .regular ? 32 : 16)
                    .sheet(isPresented: $viewModel.showListSelection) {
                        ListSelectionSheet(character: character)
                    }
                }
                .padding(sizeClass == .regular ? 32 : 16)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(20)
                .padding(.horizontal, sizeClass == .regular ? 32 : 16)
            }
            .padding(.top)
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
    let isIPad: Bool
    let destination: Destination
    
    init(title: String, icon: String, isIPad: Bool = false, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.icon = icon
        self.isIPad = isIPad
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: isIPad ? 12 : 8) {
                Image(systemName: icon)
                    .font(isIPad ? .system(size: 32, weight: .semibold) : .title2)
                Text(title)
                    .font(isIPad ? .title3.bold() : .callout.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isIPad ? 24 : 12)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .fill(Color.red)
                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
            )
            .foregroundColor(.white)
        }
    }
}
