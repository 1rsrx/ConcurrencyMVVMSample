//
//  SearchRepositoryViewModel.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/02/02.
//

import Foundation
import Combine

@MainActor
class SearchRepositoryViewModel {

    // Output
    @Published var errorMessage = ""
    @Published var repositories = [Repository]()
    @Published var isLoading = false

    private var searchText = ""

    init() {

    }
}

extension SearchRepositoryViewModel {
    func onSearchTextChanged(_ text: String) {
        self.searchText = text
    }

    func onSearchButtonTapped() async {
//        if isLoading {
//            return
//        }
//
//        isLoading = true
//        defer {
//            isLoading = false
//        }
//
//        do {
//            let repositories = try await model.fetchRepositries(keyword: searchText)
//            self.repositories = repositories
//        } catch {
//            errorMessage = error.localizedDescription
//        }

    }
}
