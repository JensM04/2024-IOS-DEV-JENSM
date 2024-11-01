import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MarvelViewModel()
    @State private var showMenu = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
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
                                    .tag(0)
                    
                    Text("Comics").tag(1)
                    
                    Text("Events").tag(2)
                    
                    Text("Series").tag(3)
                }
                
                SideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)
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
