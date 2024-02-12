//
//  CountriesListPresenterMocks.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 12.02.2024.
//

import XCTest
@testable import CountriesListApp
import CoreData


final class MockCountriesListPresenter {

    static let mockCountry = Country(
        name: "Test Country",
        continent: "Test Continent",
        capital: "Test Capital",
        population: 1000000,
        descriptionSmall: "Test Description Small",
        description: "Test Description",
        image: "Test Img", countryInfo:
            CountryInfo(images: ["Test Image 1", "Test Image 2"],
                        flag: "Test Flag")
    )
}

class MockDataLoader: DataLoadable {
    var loadCallCount = 0
    
    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void) {
        loadCallCount += 1
    }
}

class MockCoreDataManager: CoreDataManagerProtocol {
    
    var savedCountries: [CountryPersistanceObject] = []
    
    let mockManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    func saveCountry(from serverModel: Country) {
        
        let countryPersistenceObject = CountryPersistanceObject(context: mockManagedObjectContext)
        
        countryPersistenceObject.name = serverModel.name
        countryPersistenceObject.continent = serverModel.continent
        countryPersistenceObject.capital = serverModel.capital
        countryPersistenceObject.population = Int64(serverModel.population)
        countryPersistenceObject.descriptionSmall = serverModel.descriptionSmall
        countryPersistenceObject.descriptionFull = serverModel.description
        countryPersistenceObject.flag = serverModel.countryInfo.flag
        countryPersistenceObject.images = serverModel.countryInfo.images
        
        savedCountries.append(countryPersistenceObject)
    }
    
    func hasSavedCountries() -> Bool {
        if savedCountries.isEmpty {
            false
        } else {
            true
        }
    }
    
    func clearData() {
        savedCountries = []
    }
    
    func fetchAllCountries() -> [CountryPersistanceObject] {
        savedCountries
    }
}
