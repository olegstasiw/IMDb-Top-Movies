//
//  Movie.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Foundation

struct Movie: Hashable {
    //change
    let id = UUID()
    let name: String
}
