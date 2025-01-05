//
//  ListsView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 05/01/2025.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MarvelList.createdAt) var lists: [MarvelList]
    @State private var isShowingCreateSheet = false
    @State private var newListName = ""
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lists) { list in
                        NavigationLink(destination: ListDetailView(list: list)) {
                            VStack(alignment: .leading) {
                                Text(list.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, horizontalSizeClass == .compact ? 2 : 4)
                                Text("\(list.characters.count) characters")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, horizontalSizeClass == .compact ? 0 : 2)
                            }
                            .padding(horizontalSizeClass == .compact ? 8 : 16)
                        }
                    }
                    .onDelete(perform: deleteList)
                }
                .navigationTitle("My Lists")
                .listStyle(PlainListStyle())

                //+ button voor nieuwe lijst
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isShowingCreateSheet = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $isShowingCreateSheet) {
                    NavigationView {
                        Form {
                            TextField("List Name", text: $newListName)
                                .font(.title3)
                                .padding()
                        }
                        .navigationTitle("Create New List")
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                isShowingCreateSheet = false
                                newListName = ""
                            },
                            trailing: Button("Create") {
                                createList()
                            }
                            .disabled(newListName.isEmpty)
                        )
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func createList() {
        let list = MarvelList(name: newListName)
        modelContext.insert(list)
        newListName = ""
        isShowingCreateSheet = false
    }

    private func deleteList(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(lists[index])
        }
    }
}

struct ListSelectionSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MarvelList.createdAt) private var lists: [MarvelList]
    @Environment(\.dismiss) private var dismiss
    let character: Character
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    init(character: Character) {
        self.character = character
        _lists = Query(sort: \MarvelList.createdAt, order: .reverse)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(lists) { list in
                    Button(action: {
                        addCharacterToList(list)
                    }) {
                        HStack {
                            Text(list.name)
                                .font(.title3)
                            Spacer()
                            if list.characters.contains(where: { $0.id == character.id }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                            }
                        }
                        .padding(horizontalSizeClass == .compact ? 10 : 16)
                    }
                }
            }
            .navigationTitle("Add to List")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private func addCharacterToList(_ list: MarvelList) {
        if !list.characters.contains(where: { $0.id == character.id }) {
            list.characters.append(character)
        }
        dismiss()
    }
}

struct ListDetailView: View {
    @Bindable var list: MarvelList
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        List {
            ForEach(list.characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character, viewModel: MarvelViewModel())) {
                    HStack {
                        if let fullPath = character.thumbnail?.fullPath,
                           let url = URL(string: fullPath) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: horizontalSizeClass == .compact ? 50 : 70, height: horizontalSizeClass == .compact ? 50 : 70)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        Text(character.name ?? "Unknown Character")
                            .font(horizontalSizeClass == .compact ? .body : .title3)
                            .padding(.leading, 8)
                    }
                    .padding(horizontalSizeClass == .compact ? 8 : 16)
                }
            }
            .onDelete { indices in
                indices.forEach { index in
                    list.characters.remove(at: index)
                }
            }
        }
        .navigationTitle(list.name)
    }
}
