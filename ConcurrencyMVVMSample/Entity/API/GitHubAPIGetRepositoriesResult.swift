//
//  GitHubAPIGetRepositoriesResult.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/02/02.
//

import Foundation

struct GitHubAPIGetRepositoriesResult: Codable {
    var items: [Repository]
}

struct Repository: Codable {
    var id: Int
    var full_name: String
    var description: String?
    var html_url: String
}
