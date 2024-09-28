//
//  ContentView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    
    var body: some View{
        NavigationStack{
            ZStack {
                VStack{
                    Text("TEST 123")
                }
                
                SideMenuView(isShowing: $showMenu)
            }
            .toolbar(showMenu ? .hidden: .visible, for: .navigationBar)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
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

