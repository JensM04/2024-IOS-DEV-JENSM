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

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lists) { list in
                        NavigationLink(destination: ListDetailView(list: list)) {
                            VStack(alignment: .leading) {
                                Text(list.name)
                                    .font(.headline)
                                Text("\(list.characters.count) characters")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteList)
                }
                .navigationTitle("My Lists")

                //+ button voor nieuwe lijst
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isShowingCreateSheet = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.red)
                        }
                    }
                }
                .sheet(isPresented: $isShowingCreateSheet) {
                    NavigationView {
                        Form {
                            TextField("List Name", text: $newListName)
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
                            Spacer()
                            if list.characters.contains(where: { $0.id == character.id }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
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
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        Text(character.name ?? "Unknown Character")
                            .padding(.leading, 8)
                    }
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
