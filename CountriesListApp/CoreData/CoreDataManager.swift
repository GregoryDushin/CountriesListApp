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
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
}

public extension CoreDataManager {
    
    func saveCountry(name: String, continent: String, capital: String, population: Int64, descriptionSmall: String, descriptionFull: String, images: [String], flag: String) {
        let fetchRequest: NSFetchRequest<CountryPersistance> = CountryPersistance.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: L10n.formatFetchRequest, name)
        
        do {
            let existingCountries = try context.fetch(fetchRequest)
            if let existingCountry = existingCountries.first {
                existingCountry.continent = continent
                existingCountry.capital = capital
                existingCountry.population = population
                existingCountry.descriptionSmall = descriptionSmall
                existingCountry.descriptionFull = descriptionFull
                existingCountry.flag = flag
                existingCountry.images = images
            } else {
                let entity = CountryPersistance(entity: CountryPersistance.entity(), insertInto: context)
                entity.name = name
                entity.continent = continent
                entity.capital = capital
                entity.population = population
                entity.descriptionSmall = descriptionSmall
                entity.descriptionFull = descriptionFull
                entity.flag = flag
                entity.images = images
            }
            
            try context.save()
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
    
    func hasSavedCountries() -> Bool {
        let fetchRequest: NSFetchRequest<CountryPersistance> = CountryPersistance.fetchRequest()
        
        do {
            let countries = try context.fetch(fetchRequest)
            return !countries.isEmpty
        } catch {
            print("Error checking for saved countries: \(error)")
            return false
        }
    }
    
    func clearData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CountryPersistance.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error clearing Core Data: \(error)")
        }
    }
}


