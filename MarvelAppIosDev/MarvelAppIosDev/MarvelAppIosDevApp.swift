//
//  MarvelAppIosDevApp.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct MarvelAppIosDevApp: App {
    let modelContainer: ModelContainer
    
    init() {
        //firebase config
        FirebaseApp.configure()
        
        //swiftdata config
        do {
            let schema = Schema([MarvelList.self])
            let modelConfiguration = ModelConfiguration(schema: schema)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            //default fav list
            let context = modelContainer.mainContext
            let descriptor = FetchDescriptor<MarvelList>(
                predicate: #Predicate<MarvelList> { list in
                    list.name == "Favorites"
                }
            )
            let existingFavorites = try context.fetch(descriptor)
            
            if existingFavorites.isEmpty {
                let favoritesList = MarvelList(name: "Favorites")
                context.insert(favoritesList)
            }
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}


