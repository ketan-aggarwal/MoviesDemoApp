//
//  MovieEntity+CoreDataProperties.swift
//  
//
//  Created by Ketan Aggarwal on 07/12/23.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var vote_average: Double

}
