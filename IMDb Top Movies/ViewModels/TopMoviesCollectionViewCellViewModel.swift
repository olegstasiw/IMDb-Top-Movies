//
//  TopMoviesCollectionViewCellViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Combine
import Foundation

protocol TopMoviesCollectionViewCellViewModelProtocol {
    func getImageDataFromCache(id: String) -> Data?
    func saveImageDataToCache(id: String, data: Data)
    var error: CurrentValueSubject<String?, Never> { get }
}

class TopMoviesCollectionViewCellViewModel: TopMoviesCollectionViewCellViewModelProtocol {
    
    let imageCacheService: ImageCacheService
    var error = CurrentValueSubject<String?, Never>(nil)
    
    init(imageCacheService: ImageCacheService = ImageCacheManager()) {
        self.imageCacheService = imageCacheService
    }
    
    func getImageDataFromCache(id: String) -> Data? {
        return imageCacheService.read(fileName: id)
    }
    
    func saveImageDataToCache(id: String, data: Data) {
        imageCacheService.write(filename: id, data: data) { [weak self] error in
            self?.error.value = error?.localizedDescription
        }
    }
}
