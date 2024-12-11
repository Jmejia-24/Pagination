//
//  HomeView.swift
//  Pagination
//
//  Created by Byron on 12/10/24.
//

import SwiftUI

struct HomeView: View {

    @State var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                    ForEach(viewModel.photos) { photo in
                        PhotoCardView(photo: photo)
                    }
                }
                .overlay(alignment: .bottom) {
                    if viewModel.isLoading {
                        ProgressView()
                            .offset(y: 30)
                    }
                }
                .padding(15)
                .padding(.bottom, 15)
                .scrollTargetLayout()
            }
            .scrollPosition(id: Binding<String?>.init(get: {
                return ""
            }, set: { newValue in
                viewModel.activePhotoID = newValue
            }), anchor: .bottomTrailing)
            .onChange(of: viewModel.activePhotoID, { oldValue, newValue in
                if newValue == viewModel.lastPhotoID, !viewModel.isLoading, viewModel.page != viewModel.maxPage {
                    viewModel.page += 1
                    viewModel.fetchPhotos()
                }
            })
            .onAppear {
                if viewModel.photos.isEmpty {
                    viewModel.fetchPhotos()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Increase Page limit to 8") {
                            viewModel.maxPage = 8
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.below.rectangle")
                    }
                }
            }
        }
        .navigationTitle("Photos")
    }
}

#Preview {
    HomeView()
}
