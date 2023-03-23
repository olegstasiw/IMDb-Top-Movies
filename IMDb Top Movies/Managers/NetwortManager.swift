//
//  NetwortManager.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation
import Combine

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
            return "Data is empty. Check your request limit"
        }
    }
}


protocol NetworkService {
    func getMovies() -> AnyPublisher<[Movie], Error>
}

class NetwortManager: NetworkService {
    
    let urlBuilder: URLBuilderProtocol
    
    init(urlBuilder: URLBuilderProtocol = URLBuilder.shared) {
        self.urlBuilder = urlBuilder
    }
    
    func getMovies() -> AnyPublisher<[Movie], Error> {
        guard let url = urlBuilder.buildTopMoviesURL() else { return Fail(error: APIError.invalidURL).eraseToAnyPublisher() }
        return fetch(url)
            .tryMap { (response: MoviesList) -> [Movie] in
                guard !response.items.isEmpty else { throw APIError.emptyData }
                return Array(response.items.prefix(10))
            }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
