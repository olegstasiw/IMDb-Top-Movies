//
//  ImageItem+CoreDataProperties.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//
//

import Foundation
import CoreData


extension ImageItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageItem> {
        return NSFetchRequest<ImageItem>(entityName: "ImageItem")
    }

    @NSManaged public var image: Data?
    @NSManaged public var url: String?
    @NSManaged public var id: String?

}

extension ImageItem : Identifiable {

}
