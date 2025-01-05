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
                VStack {
                    if viewModel.isLoading {
                        VStack {
                            ProgressView("Loading characters...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .padding()
                        }
                    } else {
                        TabView(selection: $selectedTab) {
                            characterGridView
                                .tag(0)
                        
                            ComicListView(viewModel: viewModel, isForAllComics: true)
                                  .tag(1)
                        
                            ListsView().tag(2)
                        }
                    }
                }

                SideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)

                //paginatie
                if selectedTab == 0 {
                    VStack {
                        Spacer()
                        paginationButtons
                    }
                }
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

    private var characterGridView: some View {
        GeometryReader { geometry in
            ScrollView {
                let columns = adaptiveColumns(for: geometry.size.width)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.characters, id: \.id) { character in
                        NavigationLink(
                            destination: CharacterDetailView(character: character, viewModel: viewModel)
                        ) {
                            characterCard(for: character)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                if viewModel.characters.isEmpty {
                    viewModel.fetchAllCharacters(page: viewModel.currentCharacterPage)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }

    private func characterCard(for character: Character) -> some View {
        CharacterCardView(
            name: character.name ?? "Unknown Character",
            imageUrl: character.thumbnail?.fullPath
        )
        .foregroundColor(.primary)
    }

    private func adaptiveColumns(for width: CGFloat) -> [GridItem] {
        let minCardWidth: CGFloat = 150
        let spacing: CGFloat = 16
        let columnsCount = max(Int((width - spacing) / (minCardWidth + spacing)), 1)
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnsCount)
    }

    private var paginationButtons: some View {
        HStack {
            Spacer()

            //back to eerste pagina
            Button(action: {
                viewModel.currentCharacterPage = 1
                viewModel.fetchAllCharacters(page: viewModel.currentCharacterPage)
            }) {
                Text("First")
                    .padding()
                    .background(viewModel.currentCharacterPage > 1 ? Color.red : Color.gray)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .disabled(viewModel.currentCharacterPage <= 1)

            //vorige pagina
            Button(action: {
                if viewModel.currentCharacterPage > 1 {
                    viewModel.currentCharacterPage -= 1
                    viewModel.fetchAllCharacters(page: viewModel.currentCharacterPage)
                }
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(viewModel.currentCharacterPage > 1 ? .red : .gray)
            }
            .disabled(viewModel.currentCharacterPage <= 1)

            Text("\(viewModel.currentCharacterPage) of \(viewModel.totalCharacterPages)")
                .padding(.horizontal)

            //volgende pagina
            Button(action: {
                if viewModel.currentCharacterPage < viewModel.totalCharacterPages {
                    viewModel.currentCharacterPage += 1
                    viewModel.fetchAllCharacters(page: viewModel.currentCharacterPage)
                }
            }) {
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(viewModel.currentCharacterPage < viewModel.totalCharacterPages ? .red : .gray)
            }
            .disabled(viewModel.currentCharacterPage >= viewModel.totalCharacterPages)

            //laatste pagina
            Button(action: {
                viewModel.currentCharacterPage = viewModel.totalCharacterPages
                viewModel.fetchAllCharacters(page: viewModel.currentCharacterPage)
            }) {
                Text("Last")
                    .padding()
                    .background(viewModel.currentCharacterPage < viewModel.totalCharacterPages ? Color.red : Color.gray)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .disabled(viewModel.currentCharacterPage >= viewModel.totalCharacterPages)

            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    CharactersView()
}
