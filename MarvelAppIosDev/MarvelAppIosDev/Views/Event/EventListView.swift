//
//  EventListView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 04/01/2025.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var viewModel: MarvelViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                EventLoadingView()
            } else if viewModel.events.isEmpty {
                EventEmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.events, id: \.id) { event in
                            EnhancedEventCard(event: event)
                        }
                    }
                    .padding(.vertical, 24)
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16)
            }
        }
        .onAppear {
            if let characterId = viewModel.character?.id {
                viewModel.fetchEvents(characterId: characterId)
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct EnhancedEventCard: View {
    let event: Event
    @State private var isExpanded = false
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var imageHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 300 : 200
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //foto
            if let thumbnailPath = event.thumbnail?.fullPath,
               let url = URL(string: thumbnailPath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: imageHeight)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: imageHeight)
                        .overlay(
                            ProgressView()
                                .tint(.red)
                        )
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                //titel + pijltje voor expand
                HStack {
                    Text(event.title)
                        .font(sizeClass == .regular ? .title2 : .title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .padding(.top, 16)
                
                //start en eind datum event
                HStack(spacing: adaptiveSpacing) {
                    DateView(label: "Starts", date: formatDate(event.start))
                    Divider()
                        .frame(height: 24)
                    DateView(label: "Ends", date: formatDate(event.end))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                //omschrijving
                if let description = event.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(isExpanded ? nil : 3)
                } else {
                    Text("No description available.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .animation(.easeInOut, value: isExpanded)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
    
    private var adaptiveSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16
    }
    
    private func formatDate(_ dateString: String) -> String {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = customFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }
        return "Unknown"
    }
}

struct DateView: View {
    let label: String
    let date: String
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .foregroundColor(.red)
                .imageScale(sizeClass == .regular ? .large : .medium)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(sizeClass == .regular ? .subheadline : .caption)
                    .foregroundColor(.gray)
                Text(date)
                    .font(sizeClass == .regular ? .subheadline : .caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct EventLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.red)
            Text("Loading events...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EventEmptyStateView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: sizeClass == .regular ? 80 : 60))
                .foregroundColor(.red)
            
            VStack(spacing: 12) {
                Text("No Events Found")
                    .font(sizeClass == .regular ? .title : .title2)
                    .bold()
                    .foregroundColor(.primary)
                
                Text("The events for this character couldn't be found.")
                    .font(sizeClass == .regular ? .title3 : .body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, sizeClass == .regular ? 48 : 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
