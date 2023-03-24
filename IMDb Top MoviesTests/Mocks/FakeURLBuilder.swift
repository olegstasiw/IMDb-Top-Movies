//
//  FakeURLBuilder.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

@testable import IMDb_Top_Movies
import Foundation

class FakeURLBuilder: URLBuilderProtocol {
    func buildTopMoviesURL() -> URL? {
        return nil
    }
    
    func buildSmallImageResizeURL(imageURL: String) -> URL? {
        return nil
    }
    
    func buildLargeImageResizeURL(imageURL: String) -> URL? {
        return nil
    }
}
