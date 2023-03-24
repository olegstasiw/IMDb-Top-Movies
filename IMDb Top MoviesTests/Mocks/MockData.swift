//
//  MockData.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

@testable import IMDb_Top_Movies

struct MockData {
    static let moviesWithOneElement = [Movie(id: "id",
                                             rank: "1",
                                             title: "Title",
                                             image: "imageURL",
                                             imDbRating: "9.0",
                                             year: "2023",
                                             crew: "Test crew",
                                             imDbRatingCount: "1000")]
    
    static let mockMovie = Movie(id: "id",
                                 rank: "1",
                                 title: "Title",
                                 image: "imageURL",
                                 imDbRating: "9.0",
                                 year: "2023",
                                 crew: "Test crew",
                                 imDbRatingCount: "1000")
}
