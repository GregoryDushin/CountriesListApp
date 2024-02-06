//
//  CountriesListAppTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 06.02.2024.
//

import XCTest
@testable import CountriesListApp

final class CountriesListAppTests: XCTestCase {
    
    // MARK: - Test cases
    
    func testLoadData_Success() {
        
        let mockSession = MockURLSession(data: DataLoaderMocks.mockData, response: nil, error: nil)
        let dataLoader = DataLoader(session: mockSession)
        var actualResult: CountryResponse?
        var error: Error?
        let expectation = self.expectation(description: "Data loaded successfully")
        
        dataLoader.loadData(from: DataLoaderMocks.mockUrl, responseType: CountryResponse.self) { result in
            switch result {
            case .success(let result):
                actualResult = result
            case .failure(let err):
                error = err
            }

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(error)
        XCTAssertEqual(actualResult, DataLoaderMocks.expectedResult)
    }
    
    func testLoadData_Failure() {
        
        let mockSession = MockURLSession(data: nil, response: nil, error: LoaderError.dataFailed)
        
        let dataLoader = DataLoader(session: mockSession)
        var actualError: Error?
        let expectation = self.expectation(description: "Data loading failed")
        
        dataLoader.loadData(from: DataLoaderMocks.mockUrl, responseType: CountryResponse.self) { result in
            switch result {
            case .success:
                break
            case .failure(let err):
                actualError = err
            }

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(actualError)
    }
}
