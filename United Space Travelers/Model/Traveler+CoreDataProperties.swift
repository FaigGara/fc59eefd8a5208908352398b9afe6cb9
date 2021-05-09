//
//  Traveler+CoreDataProperties.swift
//  United Space Travelers
//
//  Created by Faiq on 8.05.2021.
//
//

import Foundation
import CoreData


extension Traveler {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Traveler> {
        return NSFetchRequest<Traveler>(entityName: "Traveler")
    }

    @NSManaged public var name: String?
    @NSManaged public var speed: Int64
    @NSManaged public var damageCapasity: Int64
    @NSManaged public var materialCapasity: Int64
    @NSManaged public var hardness: Int64
    @NSManaged public var coordinateX: Float
    @NSManaged public var coordinateY: Float
    @NSManaged public var station: Station?

}
