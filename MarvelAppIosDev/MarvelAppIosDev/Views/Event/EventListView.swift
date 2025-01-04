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
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.events, id: \.id) { event in
                            EnhancedEventCard(event: event)
                        }
                    }
                    .padding()
                }
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
    @State private var imageHeight: CGFloat = 200
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //foto
            if let thumbnail = event.thumbnail {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: "\(thumbnail.path).\(thumbnail.extension)")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            Color.gray.opacity(0.3)
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        @unknown default:
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: geometry.size.width, height: imageHeight)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: imageHeight)
            }
            
            //titel
            VStack(alignment: .leading, spacing: 12) {
                Text(event.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                //start en eind datum event
                HStack(spacing: 16) {
                    DateView(label: "Starts", date: formatDate(event.start))
                    DateView(label: "Ends", date: formatDate(event.end))
                }
                
                //omschrijving
                VStack(alignment: .leading, spacing: 8) {
                    if let description = event.description, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(isExpanded ? nil : 3)
                            .animation(.easeInOut, value: isExpanded)
                        
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Text(isExpanded ? "Show Less" : "Read More")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("No description available.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(16)
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
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        
        if let date = formatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }
        return "Unknown"
    }
}

struct DateView: View {
    let label: String
    let date: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .foregroundColor(.red)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(date)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct EventLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
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
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("No Events Found")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            Text("The events for this character couldn't be found.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
