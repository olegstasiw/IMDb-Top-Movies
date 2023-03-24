//
//  TopMoviesCollectionViewCellViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

protocol TopMoviesCollectionViewCellViewModelProtocol {
    func getImageDataFromCache(id: String) -> Data?
    func saveImageDataToCache(id: String, url: String, data: Data)
}

class TopMoviesCollectionViewCellViewModel: TopMoviesCollectionViewCellViewModelProtocol {
    
    let cacheManager: CoreDataManagerProtocol
    
    init(cacheManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.cacheManager = cacheManager
    }
    
    func getImageDataFromCache(id: String) -> Data? {
        switch cacheManager.getImage(id: id) {
            
        case .success(let data):
            return data
        case .failure(let error):
            print(error)
            return nil
        }
    }
    
    func saveImageDataToCache(id: String, url: String, data: Data) {
        cacheManager.saveImage(id: id, imageUrl: url, data: data) { error in
            // To do
        }
    }
}
