//
//  Favourite+CoreDataProperties.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 18.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var type: Int16
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var genreIDs: [Int]?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var date: String?
    @NSManaged public var voteAverage: Double

}
