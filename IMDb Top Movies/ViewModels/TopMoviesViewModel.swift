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
    var error: CurrentValueSubject<String?, Never> { get }
    var dataDidChange: ((TopMoviesViewModelProtocol) -> Void)? { get set }
    func fetchData(completion: (() -> Void)?)
}

class TopMoviesViewModel: TopMoviesViewModelProtocol {
    var movies: [Movie] = [] {
        didSet {
            dataDidChange?(self)
        }
    }

    var dataDidChange: ((TopMoviesViewModelProtocol) -> Void)?
    var error = CurrentValueSubject<String?, Never>(nil)
    let networkManager: NetworkService

    private var cancellable = Set<AnyCancellable>()
    
    init(networkManager: NetworkService = NetwortManager()) {
        self.networkManager = networkManager
    }

    func fetchData(completion: (() -> Void)?) {
        networkManager.getMovies()
            .sink { [weak self] result in
                if case .failure(let error) = result {
                    self?.error.value = error.localizedDescription
                    completion?()
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
                completion?()
            }
            .store(in: &cancellable)

    }
}
