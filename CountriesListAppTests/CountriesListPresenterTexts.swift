//
//  CountriesListPresenterTexts.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 07.02.2024.
//

import XCTest
@testable import CountriesListApp
import CoreData

class CountriesListPresenterTests: XCTestCase {
    
    var presenter: CountriesListPresenter!
    var mockDataLoader: MockDataLoader!
    var mockCoreDataManager: MockCoreDataManager!
    var mockCountryPersistenceObject: CountryPersistanceObject!
    var mockManagedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader()
        mockCoreDataManager = MockCoreDataManager()
        presenter = CountriesListPresenter(dataLoader: mockDataLoader)
        presenter.coreDataManager = mockCoreDataManager
        
        
        mockManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        mockCountryPersistenceObject = CountryPersistanceObject(context: mockManagedObjectContext)
        
        mockCountryPersistenceObject.name = "Mock Country"
        mockCountryPersistenceObject.continent = "Mock Continent"
        mockCountryPersistenceObject.capital = "Mock Capital"
        mockCountryPersistenceObject.population = 1000000
        mockCountryPersistenceObject.descriptionSmall = "Mock Description Small"
        mockCountryPersistenceObject.descriptionFull = "Mock Description Full"
        mockCountryPersistenceObject.flag = "Mock Flag"
        mockCountryPersistenceObject.images = ["Mock Image 1", "Mock Image 2"]
    }
    
    override func tearDown() {
        presenter = nil
        mockDataLoader = nil
        mockCoreDataManager = nil
        mockCountryPersistenceObject = nil
        mockManagedObjectContext = nil
        super.tearDown()
    }
    
    func testGetData_WithSavedCountries_ShouldLoadFromCoreData() {
        
        mockCoreDataManager.savedCountries = [mockCountryPersistenceObject]
        
        presenter.getData()
        
        XCTAssertNotNil(presenter.countries)
        XCTAssertEqual(presenter.countries?.count, 1)
        XCTAssertEqual(presenter.countries?[0].name, "Mock Country")
        XCTAssertNil(presenter.error)
        XCTAssertEqual(mockDataLoader.loadCallCount, 0)
    }
    
    func testGetData_WithoutSavedCountries_ShouldLoadFromNetwork() {
        mockCoreDataManager.savedCountries = []
        presenter.getData()
        XCTAssertEqual(mockDataLoader.loadCallCount, 1)
    }
    
    func testLoadNextPage_WithNextPageUrl_ShouldLoadNextPage() {
        
        presenter.nextPageUrl = "test.com"
        presenter.loadNextPage()
        XCTAssertEqual(mockDataLoader.loadCallCount, 1)
    }
    
    func testClearData() {
        presenter.clearMemory()
        XCTAssertTrue(mockCoreDataManager.savedCountries.isEmpty, "savedCountries should be empty after clearData is called")
    }
    
    func testSavedCountry() {
        
        mockCoreDataManager.savedCountries = []
        
        let mockCountry = Country(name: "Test Country", continent: "Test Continent", capital: "Test Capital", population: 1000000, descriptionSmall: "Test Description Small", description: "Test Description", image: "Test Img", countryInfo: CountryInfo(images: ["Test Image 1", "Test Image 2"], flag: "Test Flag"))
        
        presenter.coreDataManager.saveCountry(from: mockCountry)
        
        debugPrint(mockCoreDataManager.savedCountries.count)
        
        XCTAssertTrue(mockCoreDataManager.savedCountries.count == 1, "One country should be saved")
    }
    
    
    
}

class MockDataLoader: DataLoadable {
    var loadCallCount = 0
    
    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void) {
        loadCallCount += 1
    }
}

class MockCoreDataManager: CoreDataManagerProtocol {
    
    var savedCountries: [CountryPersistanceObject] = []
    
    func saveCountry(from serverModel: Country) {
        
        let countryPersistenceObject = CountryPersistanceObject()
        
        countryPersistenceObject.name = serverModel.name
        countryPersistenceObject.continent = serverModel.continent
        countryPersistenceObject.capital = serverModel.capital
        countryPersistenceObject.population = Int64(serverModel.population)
        countryPersistenceObject.descriptionSmall = serverModel.descriptionSmall
        countryPersistenceObject.descriptionFull = serverModel.description
        countryPersistenceObject.flag = serverModel.countryInfo.flag
        countryPersistenceObject.images = serverModel.countryInfo.images
        
        savedCountries.append(countryPersistenceObject)
        debugPrint(savedCountries.count)
    }
    
    func hasSavedCountries() -> Bool {
        if savedCountries.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func clearData() {
        savedCountries = []
    }
    
    func fetchAllCountries() -> [CountryPersistanceObject] {
        return savedCountries
    }
}
