//
//  MovieItem+CoreDataProperties.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//
//

import Foundation
import CoreData


extension MovieItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieItem> {
        return NSFetchRequest<MovieItem>(entityName: "MovieItem")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var imDbRating: String?
    @NSManaged public var rank: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var crew: String?
    @NSManaged public var imDbRatingCount: String?
    
}

extension MovieItem : Identifiable {

}
