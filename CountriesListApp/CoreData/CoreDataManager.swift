//
//  CoreDataManager.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 23.01.2024.
//

import UIKit
import CoreData

// MARK: - CRUD

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelrgate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        var result: NSManagedObjectContext?
        DispatchQueue.main.sync {
            result = appDelrgate.persistentContainer.viewContext
        }
        guard let unwrappedResult = result else {
            fatalError("Unable to obtain NSManagedObjectContext")
        }
        return unwrappedResult
    }
}

public extension CoreDataManager {
    
    func saveCountry(name: String, continent: String, capital: String, population: Int64, descriptionSmall: String, descriptionFull: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "CountryPersistance", in: context) else {
            return
        }
        let entity = CountryPersistance(entity: entityDescription, insertInto: context)
        entity.name = name
        entity.continent = continent
        entity.capital = capital
        entity.population = population
        entity.descriptionSmall = descriptionSmall
        entity.descriptionFull = descriptionFull
        
        do {
            try context.save()
            print(context)
        } catch {
            print("Error saving country: \(error)")
        }
    }
    
    func fetchAllCountries() -> [CountryPersistance] {
        let fetchRequest: NSFetchRequest<CountryPersistance> = CountryPersistance.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching countries: \(error)")
            return []
        }
    }
}

