//
//  CountriesListPresenterTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 07.02.2024.
//

import XCTest
@testable import CountriesListApp
import CoreData

final class CountriesListPresenterTests: XCTestCase {
    
    var presenter: CountriesListPresenter!
    var mockDataLoader: MockDataLoader!
    var mockCoreDataManager: MockCoreDataManager!
    var mockCountryPersistenceObject: CountryPersistanceObject!
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader()
        mockCoreDataManager = MockCoreDataManager()
        presenter = CountriesListPresenter(
            dataLoader: mockDataLoader,
            coreDataManager: mockCoreDataManager
        )
        
        mockCountryPersistenceObject = CountryPersistanceObject(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        
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
        super.tearDown()
    }
    
    func testGetData_WithSavedCountries_ShouldLoadFromCoreData() throws {
        
        mockCoreDataManager.savedCountries = [mockCountryPersistenceObject]
        
        presenter.getData()
        
        let countries = try XCTUnwrap(presenter.countries , "countries should not be nil")
        
        XCTAssertNotNil(countries)
        XCTAssertEqual(countries.count, 1)
        XCTAssertEqual(countries[0].name, "Mock Country")
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
        mockCoreDataManager.saveCountry(from: MockCountriesListPresenter.mockCountry)
        XCTAssertTrue(mockCoreDataManager.savedCountries.count == 1, "One country has to be saved")
    }
}
