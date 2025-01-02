//
//  CharacterDetailView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 02/01/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    //presentatiemodus (enkel voor back button)
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                //afbeelding
                if let fullPath = character.thumbnail?.fullPath,
                   let url = URL(string: fullPath) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Text("No image available")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                //description
                if let description = character.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .padding(.bottom, 8)
                } else {
                    Text("No description available.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                }
                
                //buttons
                HStack(spacing: 16) {
                    Button(action: {
                        //todo
                    }) {
                        Text("Comics")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        //todo
                    }) {
                        Text("Events")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        //todo
                    }) {
                        Text("Series")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle(character.name ?? "Unknown Character")
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.red)
        .navigationBarBackButtonHidden(true) //hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() //terug naar vorige view
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.red) 
                        .imageScale(.large)
                }
            }
        }
    }
}
