//
//  GitHubAPIError.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/02/02.
//

import Foundation
enum GitHubAPIError: Error, LocalizedError {
    case invailedURL
    case parse
    case other

    var errorDescription: String? {
        switch self {
        case .invailedURL:
            return "invailedURL"
        case .parse:
            return "parse"
        case .other:
            return "other"
        }
    }
}
