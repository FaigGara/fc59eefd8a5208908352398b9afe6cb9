//
//  Station+CoreDataProperties.swift
//  United Space Travelers
//
//  Created by Faiq on 8.05.2021.
//
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var name: String?
    @NSManaged public var coordinateX: Float
    @NSManaged public var coordinateY: Float
    @NSManaged public var capasity: Int64
    @NSManaged public var need: Int64
    @NSManaged public var stock: Int64
    @NSManaged public var isFav: Bool
    @NSManaged public var wasTravel: Bool
    @NSManaged public var traveler: Traveler?

}
