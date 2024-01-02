//
//  MovieInfoEntity+CoreDataProperties.swift
//  
//
//  Created by Ketan Aggarwal on 07/12/23.
//
//

import Foundation
import CoreData


extension MovieInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieInfoEntity> {
        return NSFetchRequest<MovieInfoEntity>(entityName: "MovieInfoEntity")
    }

    @NSManaged public var isLiked: Bool
    @NSManaged public var languages: String?
    @NSManaged public var productionCountries: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var revenue: Int64
    @NSManaged public var runtime: Int64
    @NSManaged public var tagline: String?
    @NSManaged public var uniqueIdentifier: String?

}
