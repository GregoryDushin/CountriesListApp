//
//  CountriesListAppTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 06.02.2024.
//
import XCTest
@testable import CountriesListApp

final class CountriesListAppTests: XCTestCase {
    
    func testLoadData_Success() {
        let dataLoader = DataLoader(session: makeMockSession(data: DataLoaderMocks.mockData.data(using: .utf8), error: nil))
        var actualResult: CountryResponse?
        let expectation = expectation(description: "Data loaded successfully")
        
        dataLoader.loadData(from: DataLoaderMocks.mockUrl, responseType: CountryResponse.self) { result in
            switch result {
            case .success(let result):
                actualResult = result
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Loading data failed with error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(actualResult, "No result received")
        XCTAssertEqual(actualResult, DataLoaderMocks.expectedResult)
    }
    
    func testLoadData_Failure() {
        
        let dataLoader = DataLoader(session: makeMockSession(data: nil, error: LoaderError.dataFailed))
        var actualError: Error?
        let expectation = expectation(description: "Data loading failed")
        dataLoader.loadData(from: DataLoaderMocks.mockUrl, responseType: CountryResponse.self) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                actualError = error
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(actualError)
    }
    
    private func makeMockSession(data: Data?, error: Error?) -> URLSession {
        TestDataLoader.makeMockSession(data: data, error: error, for: DataLoaderMocks.mockUrl)
    }
}
