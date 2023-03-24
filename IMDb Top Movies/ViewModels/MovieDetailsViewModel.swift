//
//  MovieDetailsViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var movie: Movie { get }
    func getURLForLargeImage() -> URL?
    func getDictionaryWithCountingOfEachCharecterInTitle() -> [Character: Int]
    func getImageDataFromCache(id: String) -> Data?
    func saveImageDataToCache(id: String, url: String, data: Data)
    
    var crewText: String { get }
    var yearText: String { get }
    var imDbRatingText: String { get }
    var imDbRatingCountText: String { get }
    var totalCountLetterText: String { get }
}
    
class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    let movie: Movie
    let urlBuider: URLBuilderProtocol
    let cacheManager: CoreDataManagerProtocol
    
    var crewText: String {
        return "Crew: \(movie.crew)"
    }
    
    var yearText: String {
        return "Year: \(movie.year)"
    }
    
    var imDbRatingText: String {
        return "IMBd rank: \(movie.imDbRating)"
    }
    
    var imDbRatingCountText: String {
        return "Voted \(movie.imDbRatingCount) times"
    }
    
    var totalCountLetterText: String {
        return "Total count - \(movie.title.filter { $0.isLetter }.count)"
    }
    
    init(movie: Movie,
         urlBuider: URLBuilderProtocol = URLBuilder.shared,
         cacheManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.movie = movie
        self.urlBuider = urlBuider
        self.cacheManager = cacheManager
    }
    
    func getURLForLargeImage() -> URL? {
        let url = urlBuider.buildSmallImageResizeURL(imageURL: movie.image)
        return url
    }
    
    func getDictionaryWithCountingOfEachCharecterInTitle() -> [Character: Int] {
        var dictionary = [Character: Int]()
        
        var letterSet = Set<Character>()
        movie.title.forEach { letterSet.insert(Character($0.lowercased())) }
        
        letterSet.filter { $0.isLetter }.forEach { letter in
            let count = movie.title.filter { Character($0.lowercased()) == letter }.count
            
            dictionary.updateValue(count, forKey: letter)
        }
        return dictionary
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
