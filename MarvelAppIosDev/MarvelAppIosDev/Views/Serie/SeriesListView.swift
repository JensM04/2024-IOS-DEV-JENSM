//
//  SeriesListView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 05/01/2025.
//

import SwiftUI

struct SeriesListView: View {
    @ObservedObject var viewModel: MarvelViewModel
    let characterId: Int

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            if viewModel.isLoading {
                SeriesLoadingView()
            } else if viewModel.series.isEmpty {
                SeriesEmptyStateView()
            } else {
                List(viewModel.series, id: \ .resourceURI) { seriesItem in
                    VStack(alignment: .leading) {
                        Text(seriesItem.name ?? "Unknown Title")
                            .font(.headline)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchSeries(characterId: characterId)
        }
        .navigationTitle("Series")
    }
}

struct SeriesLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.red)
            Text("Loading series...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SeriesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.red)

            Text("No Series Found")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)

            Text("The series for this character couldn't be found.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

