//
//  CoreDataManager.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 23.01.2024.
//

import UIKit
import CoreData

public final class CoreDataManager {
    
    private struct Constants {
        static let formatFetchRequest = "name == %@"
        static let persistentContainerName = "CountriesListApp"
    }
    
    public static let shared = CoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var countryFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<CountryPersistanceObject> = CountryPersistanceObject.fetchRequest()
        return fetchRequest as! NSFetchRequest<NSFetchRequestResult>
    }
    
    func saveCountry(from serverModel: Country) {
        countryFetchRequest.predicate = NSPredicate(format: Constants.formatFetchRequest, serverModel.name)
        
        do {
            let existingCountries = try context.fetch(countryFetchRequest)
            if let existingCountry = existingCountries.first as? CountryPersistanceObject {
                CountryPersistanceObject.update(existingCountry, with: serverModel)
            } else {
                let countryEntity = CountryPersistanceObject.create(from: serverModel, in: context)
                context.insert(countryEntity)
            }
            
            try context.save()
        } catch {
            print("Error saving country: \(error)")
        }
    }
    
    func fetchAllCountries() -> [CountryPersistanceObject] {
        do {
            return try context.fetch(countryFetchRequest) as! [CountryPersistanceObject]
        } catch {
            print("Error fetching countries: \(error)")
            return []
        }
    }
    
    func hasSavedCountries() -> Bool {
        do {
            let countries = try context.fetch(countryFetchRequest) as! [CountryPersistanceObject]
            return !countries.isEmpty
        } catch {
            print("Error checking for saved countries: \(error)")
            return false
        }
    }
    
    func clearData() {
        do {
            try context.execute(NSBatchDeleteRequest(fetchRequest: countryFetchRequest))
        } catch {
            print("Error clearing Core Data: \(error)")
        }
    }
}

