//
//  CountriesListPresenterTexts.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 07.02.2024.
//

import XCTest
@testable import CountriesListApp

final class CountriesListPresenterTexts: XCTestCase {
    
    var presenter: CountriesListPresenter!
    var mockDataLoader: MockDataLoader!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
           super.setUp()
           mockDataLoader = MockDataLoader()
           mockCoreDataManager = MockCoreDataManager()
           presenter = CountriesListPresenter(dataLoader: mockDataLoader)
            //presenter.coreDataManager = mockCoreDataManager  //hz
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
    
    func saveCountry(from serverModel: CountriesListApp.Country) {
        print("ok")
    }
    
    func hasSavedCountries() -> Bool {
        return true
    }
    
    func clearData() {
        print("ok")
    }
    
    func fetchAllCountries() -> [CountryPersistanceObject] {
        return savedCountries
    }
}
