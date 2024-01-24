//
//  Entity+CoreDataProperties.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 23.01.2024.
//
//

import Foundation
import CoreData

@objc(CountryPersistance)
public class CountryPersistance: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var continent: String
    @NSManaged public var capital: String
    @NSManaged public var population: Int64
    @NSManaged public var descriptionSmall: String
    @NSManaged public var descriptionFull: String
    @NSManaged public var images: [String]
    @NSManaged public var flag: String
}

extension CountryPersistance {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryPersistance> {
        return NSFetchRequest<CountryPersistance>(entityName: L10n.fetchRequestEntityName)
    }
}

extension CountryPersistance: Identifiable {}
