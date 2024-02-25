//
//  Entity+CoreDataProperties.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 23.01.2024.
//
//

import Foundation
import CoreData

@objc(CountryPersistanceObject)
final public class CountryPersistanceObject: NSManagedObject {
    
    private struct Constants {
        static let fetchRequestEntityName = "CountryPersistanceObject"
    }
    
    @NSManaged public var name: String
    @NSManaged public var continent: String
    @NSManaged public var capital: String
    @NSManaged public var population: Int64
    @NSManaged public var descriptionSmall: String
    @NSManaged public var descriptionFull: String
    @NSManaged public var images: [String]
    @NSManaged public var flag: String
    @NSManaged public var contentHeight: CGFloat
    
    static func create(from serverModel: Country, in context: NSManagedObjectContext) -> CountryPersistanceObject {
        let entity = CountryPersistanceObject(entity: CountryPersistanceObject.entity(), insertInto: context)
        
        entity.name = serverModel.name
        entity.continent = serverModel.continent
        entity.capital = serverModel.capital
        entity.population = Int64(serverModel.population)
        entity.descriptionSmall = serverModel.descriptionSmall
        entity.descriptionFull = serverModel.description
        entity.flag = serverModel.countryInfo.flag
        entity.images = serverModel.countryInfo.images

        if let height = serverModel.contentHeight {
            entity.contentHeight = height
        }
        
        return entity
    }
    
    static func update(_ existingCountry: CountryPersistanceObject, with serverModel: Country) {
        existingCountry.continent = serverModel.continent
        existingCountry.capital = serverModel.capital
        existingCountry.population = Int64(serverModel.population)
        existingCountry.descriptionSmall = serverModel.descriptionSmall
        existingCountry.descriptionFull = serverModel.description
        existingCountry.flag = serverModel.countryInfo.flag
        existingCountry.images = serverModel.countryInfo.images

        if let height = serverModel.contentHeight {
            existingCountry.contentHeight = height
        }
    }
}

extension CountryPersistanceObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryPersistanceObject> {
        return NSFetchRequest<CountryPersistanceObject>(entityName: Constants.fetchRequestEntityName)
    }
}

extension CountryPersistanceObject: Identifiable {}
