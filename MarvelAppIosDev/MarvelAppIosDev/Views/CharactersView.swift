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
                    VStack {
                        ProgressView("Loading characters...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            .padding()
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        characterGridView
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

                //paginatie
                HStack {
                    Spacer()

                    //back to eerste pagina
                    Button(action: {
                        viewModel.currentPage = 1
                        viewModel.fetchAllCharacters(page: viewModel.currentPage)
                    }) {
                        Text("First")
                            .padding()
                            .background(viewModel.currentPage > 1 ? Color.red : Color.gray)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    .disabled(viewModel.currentPage <= 1)

                    //vorige pagina
                    Button(action: {
                        if viewModel.currentPage > 1 {
                            viewModel.currentPage -= 1
                            viewModel.fetchAllCharacters(page: viewModel.currentPage)
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(viewModel.currentPage > 1 ? .red : .gray)
                    }
                    .disabled(viewModel.currentPage <= 1)

                    Text("\(viewModel.currentPage) of \(viewModel.totalPages)")
                        .padding(.horizontal)

                    //volgende pagina
                    Button(action: {
                        if viewModel.currentPage < viewModel.totalPages {
                            viewModel.currentPage += 1
                            viewModel.fetchAllCharacters(page: viewModel.currentPage)
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(viewModel.currentPage < viewModel.totalPages ? .red : .gray)
                    }
                    .disabled(viewModel.currentPage >= viewModel.totalPages)

                    //laatste pagina
                    Button(action: {
                                        viewModel.currentPage = viewModel.totalPages
                                        viewModel.fetchAllCharacters(page: viewModel.currentPage)
                                    }) {
                                        Text("Last")
                                            .padding()
                                            .background(viewModel.currentPage < viewModel.totalPages ? Color.red : Color.gray)
                                            .cornerRadius(8)
                                            .foregroundColor(.white)
                                    }
                                    .disabled(viewModel.currentPage >= viewModel.totalPages)

                    Spacer()
                }
                .padding(.top)
            }
            .onAppear {
                if viewModel.characters.isEmpty {
                    viewModel.fetchAllCharacters(page: viewModel.currentPage)
                }
            }
        }
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
}

#Preview {
    CharactersView()
}
