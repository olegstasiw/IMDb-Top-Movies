//
//  APIError.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case emptyData
}

extension APIError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Bad url"
        case .emptyData:
            return "Data is empty. Check your request limit. Daily limit - 100 requests."
        }
    }
}
