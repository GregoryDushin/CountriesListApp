//
//  CoreDataManager.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 23.01.2024.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func fetchAllCountries() -> [CountryPersistanceObject]
    func saveCountry(from serverModel: Country)
    func hasSavedCountries() -> Bool
    func clearData()
    func cacheHeight(_ height: CGFloat, for key: String)
    func fetchCachedHeight(for key: String) -> CGFloat?
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private struct Constants {
        static let formatFetchRequest = "name == %@"
        static let persistentContainerName = "CountriesListApp"
        static let fetchRequestEntityName = "CountryPersistanceObject"
        static let cachedHeightsEntityName = "CachedHeight"
        static let heightAttributeName = "height"
        static let keyAttributeName = "key"
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.fetchRequestEntityName)
        return fetchRequest
    }
    
    func saveCountry(from serverModel: Country) {
        let fetchRequest: NSFetchRequest<CountryPersistanceObject> = CountryPersistanceObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", serverModel.name)

        do {
            let existingCountries = try context.fetch(fetchRequest)

            if let existingCountry = existingCountries.first {
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
            if let countries = try context.fetch(countryFetchRequest) as? [CountryPersistanceObject] {
                return countries
            } else {
                return []
            }
        } catch {
            print("Error fetching countries: \(error)")
            return []
        }
    }

    func hasSavedCountries() -> Bool {
        do {
            let countries = try context.fetch(countryFetchRequest) as? [CountryPersistanceObject] ?? []
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
    
    func cacheHeight(_ height: CGFloat, for key: String) {
        let cachedHeightEntity = NSEntityDescription.entity(forEntityName: Constants.cachedHeightsEntityName, in: context)!
        let cachedHeight = NSManagedObject(entity: cachedHeightEntity, insertInto: context)
        cachedHeight.setValue(height, forKey: Constants.heightAttributeName)
        cachedHeight.setValue(key, forKey: Constants.keyAttributeName)
        
        do {
            try context.save()
        } catch {
            print("Error caching height: \(error)")
        }
    }
    
    func fetchCachedHeight(for key: String) -> CGFloat? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Constants.cachedHeightsEntityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.keyAttributeName) == %@", key)

        do {
            let cachedHeights = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let cachedHeight = cachedHeights.first {
                return cachedHeight.value(forKey: Constants.heightAttributeName) as? CGFloat
            } else {
                return nil
            }
        } catch {
            print("Error fetching cached height: \(error)")
            return nil
        }
    }
}

