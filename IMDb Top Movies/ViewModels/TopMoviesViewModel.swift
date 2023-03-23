//
//  TopMoviesViewModel.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

protocol TopMoviesViewModelProtocol {
    var movies: [Movie] { get set}
    var dataDidChange: ((TopMoviesViewModelProtocol) -> Void)? { get set }
    func fetchData()
}

class TopMoviesViewModel: TopMoviesViewModelProtocol {
    var movies: [Movie] = [] {
        didSet {
            dataDidChange?(self)
        }
    }

    var dataDidChange: ((TopMoviesViewModelProtocol) -> Void)?

    init() { }

    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.movies = [.init(name: "first")]
        }
    }
}
