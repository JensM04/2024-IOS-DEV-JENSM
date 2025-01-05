//
//  ComicListView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 04/01/2025.
//

import SwiftUI

struct ComicListView: View {
    @ObservedObject var viewModel: MarvelViewModel
    var isForAllComics: Bool
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.comics.isEmpty {
                EmptyStateView()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: Array(
                            repeating: GridItem(.flexible(), spacing: 16),
                            count: UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
                        ),
                        spacing: 20
                    ) {
                        ForEach(viewModel.comics, id: \.id) { comic in
                            ComicCard(comic: comic)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            if isForAllComics {
                viewModel.fetchAllComics(page: viewModel.currentComicsPage)
            } else if let characterId = viewModel.character?.id {
                viewModel.fetchComics(characterId: characterId)
            }
        }
        .navigationTitle(isForAllComics ? "All Comics" : "Comics")
        .navigationBarTitleDisplayMode(.large)
    }
}


struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                ProgressView("Loading comics...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("No Comics Found")
                .font(.title2)
                .bold()
            
            Text("The comics for this character couldn't be found.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ComicCard: View {
    let comic: Comic
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //afbeelding
            if let thumbnailPath = comic.thumbnail?.fullPath,
               let url = URL(string: thumbnailPath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            ProgressView()
                                .tint(.red)
                        )
                }
            }
            
            //titel
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(comic.title ?? "Unknown Comic")
                        .font(.title3)
                        .bold()
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        //omschrijving
                        if let description = comic.description, !description.isEmpty {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(isExpanded ? nil : 2)
                        } else {
                            Text("No description available for this comic.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .animation(.easeInOut, value: isExpanded)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}
