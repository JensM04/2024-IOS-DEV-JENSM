//
//  CharactersView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 21/12/2024.
//
import SwiftUI

struct CharactersView: View {
    @StateObject private var viewModel = MarvelViewModel()
    @State private var showMenu = false
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading Characters...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    TabView(selection: $selectedTab) {
                        GeometryReader { geometry in
                            ScrollView {
                                let columns = adaptiveColumns(for: geometry.size.width)
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.characters, id: \.id) { character in
                                        NavigationLink(destination: CharacterDetailView(characterName: character.name ?? "Unknown Character")) {
                                            CharacterCardView(
                                                name: character.name ?? "Unknown Character",
                                                imageUrl: character.thumbnail?.fullPath
                                            ).foregroundColor(.primary)
                                        }.buttonStyle(.plain)
                                    }
                                }
                                .padding()
                            }
                            .onAppear {
                                if viewModel.characters.isEmpty {
                                    viewModel.fetchAllCharacters()
                                }
                            }
                        }
                        .tag(0)
                        
                        Text("Comics").tag(1)
                        
                        Text("Events").tag(2)
                        
                        Text("Series").tag(3)
                    }
                }
                
                SideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)
            }
            .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal").tint(.red)
                    })
                }
            }
        }
    }
    private func adaptiveColumns(for width: CGFloat) -> [GridItem] {
        let minCardWidth: CGFloat = 150
        let spacing: CGFloat = 16
        let columnsCount = max(Int((width - spacing) / (minCardWidth + spacing)), 1)
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
    }
}


#Preview {
    CharactersView()
}
