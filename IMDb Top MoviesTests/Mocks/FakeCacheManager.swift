//
//  FakeCacheManager.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

@testable import IMDb_Top_Movies
import Foundation

class FakeCacheManager: CoreDataManagerProtocol {
    
    func saveMoviesItems(movies: [Movie], errorCompletion: @escaping (Error?) -> Void) {

    }
    
    func getMoviesItems() -> Result<[Movie], Error> {
        return .failure(NSError(domain: "", code: 1))
    }
    
    func saveImage(id: String, imageUrl: String, data: Data, errorCompletion: @escaping (Error?) -> Void) {
        
    }
    
    func getImage(id: String) -> Result<Data?, Error> {
       return .failure(NSError(domain: "", code: 1))
    }
}

