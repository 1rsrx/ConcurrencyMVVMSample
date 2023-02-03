//
//  SearchRepositoryModel.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/02/02.
//

import Foundation
import Combine

protocol SearchRepositoryModelable {
    func fetchRepositries(keyword: String) async throws -> [Repository]
}

class SearchRepositoryModel: SearchRepositoryModelable {

    private let baseURL = "https://api.github.com/search/repositories"

    func fetchRepositries(keyword: String) async throws -> [Repository] {
        let urlString = self.baseURL + "?q=\(keyword)"
        guard let url = URL(string: urlString) else {
            throw GitHubAPIError.invailedURL
        }
        let request = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            // ステータスコードチェック
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200 {
                throw GitHubAPIError.other
            }

            // デコード
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(
                    GitHubAPIGetRepositoriesResult.self,
                    from: data
                )
                return result.items
            } catch {
                throw GitHubAPIError.parse
            }
        } catch {
            throw GitHubAPIError.other
        }
    }
}
