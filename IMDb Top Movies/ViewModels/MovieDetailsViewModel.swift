//
//  MovieDetailsViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Combine
import Foundation

protocol MovieDetailsViewModelProtocol {
    var movie: Movie { get }
    func getURLForLargeImage() -> URL?
    func getArrayWithCountingOfEachCharecterInTitle() -> [(Character, Int)]
    func getImageDataFromCache(id: String) -> Data?
    func saveImageDataToCache(id: String, data: Data)
    var error: CurrentValueSubject<String?, Never> { get }
    
    var crewText: String { get }
    var yearText: String { get }
    var imDbRatingText: String { get }
    var imDbRatingCountText: String { get }
    var totalCountLetterText: String { get }
}
    
class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    let movie: Movie
    let urlBuider: URLBuilderProtocol
    let imageCachService: ImageCacheService
    var error = CurrentValueSubject<String?, Never>(nil)

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
         imageCachService: ImageCacheService = ImageCacheManager()) {
        self.movie = movie
        self.urlBuider = urlBuider
        self.imageCachService = imageCachService
    }
    
    func getURLForLargeImage() -> URL? {
        let url = urlBuider.buildSmallImageResizeURL(imageURL: movie.image)
        return url
    }
    
    func getArrayWithCountingOfEachCharecterInTitle() -> [(Character, Int)] {
        var array = [(Character, Int)]()
        
        var letterArray = [Character]()
        for letter in movie.title {
            letterArray.append(Character(letter.lowercased()))
        }
        
        for letter in letterArray.removeDuplicates().filter({ $0.isLetter }) {
            let count = movie.title.filter { Character($0.lowercased()) == letter }.count
            array.append((letter, count))
        }
        return array
    }
    
    func getImageDataFromCache(id: String) -> Data? {
        return imageCachService.read(fileName: id)
    }
    
    func saveImageDataToCache(id: String, data: Data) {
        imageCachService.write(filename: id, data: data) { [weak self] error in
            self?.error.value = error?.localizedDescription
        }
    }
}
