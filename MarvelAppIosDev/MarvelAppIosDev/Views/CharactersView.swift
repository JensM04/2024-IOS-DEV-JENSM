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
                TabView(selection: $selectedTab) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                            ForEach(viewModel.characters, id: \.id) { character in
                                CharacterCardView(
                                    name: character.name ?? "Unknown Character",
                                    imageUrl: character.thumbnail?.fullPath
                                )
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        viewModel.fetchAllCharacters()
                    }
                    .tag(0)
                    
                    Text("Comics").tag(1)
                    
                    Text("Events").tag(2)
                    
                    Text("Series").tag(3)
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
}

#Preview {
    CharactersView()
}

