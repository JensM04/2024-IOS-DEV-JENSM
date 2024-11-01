import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MarvelViewModel()
    @State private var showMenu = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if let character = viewModel.character {
                        Text(character.name ?? "Unknown Character")
                            .font(.largeTitle)
                            .padding()
                        
                        if let description = character.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .padding()
                        } else {
                            Text("No description available")
                                .font(.body)
                                .padding()
                        }
                        
                        if let imageUrl = character.thumbnail?.fullPath, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Text("No image available")
                                .font(.caption)
                        }
                    } else {
                        Text("Loading character...")
                            .onAppear {
                                viewModel.fetchCharacter(characterId: 1009610)
                            }
                    }
                }
                
                SideMenuView(isShowing: $showMenu)
            }
            .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
            .navigationTitle("Home")
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
    ContentView()
}
