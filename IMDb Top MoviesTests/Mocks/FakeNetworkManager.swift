//
//  FakeNetworkManager.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

@testable import IMDb_Top_Movies
import Combine
import Foundation

class FakeNetworkManager: NetworkService {
    
    func getMovies() -> AnyPublisher<[Movie], Error> {
        let movies = MockData.moviesWithOneElement
        
        let result = Just(movies).setFailureType(to: Error.self).eraseToAnyPublisher()
        return result
    }
    
}
