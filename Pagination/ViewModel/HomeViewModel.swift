//
//  HomeViewModel.swift
//  Pagination
//
//  Created by Byron on 12/10/24.
//

import Foundation

@Observable
final class HomeViewModel {

    var photos: [Photo] = []
    var isLoading: Bool = false
    var page: Int = 1
    var lastFetchedPage: Int = 1
    var maxPage: Int = 5
    var activePhotoID: String?
    var lastPhotoID: String?

    func fetchPhotos() {
        Task {
            do {
                if let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true

                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: url).0
                    let photosResponse = try JSONDecoder().decode([Photo].self, from: jsonData)

                    await MainActor.run {
                        if photosResponse.isEmpty {
                            page = lastFetchedPage
                        } else {
                            photos.append(contentsOf: photosResponse)

                            lastPhotoID = photos.last?.id
                            lastFetchedPage = page
                        }

                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                lastFetchedPage = page

                print(error.localizedDescription)
            }
        }
    }
}
