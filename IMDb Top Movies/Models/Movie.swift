//
//  Movie.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

struct MoviesList: Codable {
    let items: [Movie]
}

struct Movie: Hashable, Codable {
    let id: String
    let rank: String
    let title: String
    let image: String
    let imDbRating: String
    let year: String
    let crew: String
    let imDbRatingCount: String
}
