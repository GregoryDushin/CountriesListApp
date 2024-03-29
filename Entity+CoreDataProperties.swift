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
    
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var continent: String
    @NSManaged public private(set) var capital: String
    @NSManaged public private(set) var population: Int64
    @NSManaged public private(set) var descriptionSmall: String
    @NSManaged public private(set) var descriptionFull: String
    @NSManaged public private(set) var images: [String]
    @NSManaged public private(set) var flag: String
    
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
    }
}

extension CountryPersistanceObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryPersistanceObject> {
        return NSFetchRequest<CountryPersistanceObject>(entityName: Constants.fetchRequestEntityName)
    }
}

extension CountryPersistanceObject: Identifiable {}
