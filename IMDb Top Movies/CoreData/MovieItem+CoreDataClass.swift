//
//  MovieItem+CoreDataClass.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//
//

import Foundation
import CoreData

@objc(MovieItem)
public class MovieItem: NSManagedObject {
    var movie: Movie {
        get {
            let movie = Movie(id: id ?? "",
                              rank: rank ?? "",
                              title: title ?? "",
                              image: image ?? "",
                              imDbRating: imDbRating ?? "",
                              year: year ?? "",
                              crew: crew ?? "",
                              imDbRatingCount: imDbRatingCount ?? "")
            
            return movie
        }
        set {
            id = newValue.id
            rank = newValue.rank
            title = newValue.title
            image = newValue.image
            imDbRating = newValue.imDbRating
            year = newValue.year
            crew = newValue.crew
            imDbRatingCount = newValue.imDbRatingCount
        }
    }
}
