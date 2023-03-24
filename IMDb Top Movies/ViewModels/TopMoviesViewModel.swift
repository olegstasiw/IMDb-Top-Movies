//
//  TopMoviesViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation
import Combine

protocol TopMoviesViewModelProtocol {
    var movies: [Movie] { get set}
    var filteredMovies: [Movie] { get set }
    var error: CurrentValueSubject<String?, Never> { get }
    func fetchData(completion: @escaping () -> Void)
}

class TopMoviesViewModel: TopMoviesViewModelProtocol {
    var movies: [Movie] = [] 
    var filteredMovies: [Movie] = []

    var error = CurrentValueSubject<String?, Never>(nil)
    let networkManager: NetworkService
    let cacheManager: CoreDataManagerProtocol

    private var cancellable = Set<AnyCancellable>()
    
    init(networkManager: NetworkService = NetwortManager(),
         cacheManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }

    func fetchData(completion: @escaping () -> Void) {
        readDataFromCache(completion: completion)
        
        networkManager.getMovies()
            .sink { [weak self] result in
                if case .failure(let error) = result {
                    self?.error.value = error.localizedDescription
                    completion()
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.writeCache(movies: movies)
                completion()
            }
            .store(in: &cancellable)

    }
    private func writeCache(movies: [Movie]) {
        cacheManager.saveMoviesItems(movies: movies) { error in
            // To do
        }
    }
    
    private func readDataFromCache(completion: @escaping () -> Void) {
        switch cacheManager.getMoviesItems() {
        case .success(let movies):
            self.movies = movies
            completion()
        case .failure(let error):
            self.error.value = error.localizedDescription
            completion()
        }
    }
}
