//
//  NewMoveEntity+CoreDataProperties.swift
//  
//
//  Created by Ketan Aggarwal on 12/12/23.
//
//

import Foundation
import CoreData


extension NewMoveEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewMoveEntity> {
        return NSFetchRequest<NewMoveEntity>(entityName: "NewMoveEntity")
    }

    @NSManaged public var vote_average: Double
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var id: Int64

}
