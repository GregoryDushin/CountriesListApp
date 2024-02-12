//
//  CountriesListAppTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 06.02.2024.
//
import XCTest
@testable import CountriesListApp

final class CountriesListAppTests: XCTestCase {
    
    private func makeMockSession(data: Data?, error: Error?) -> URLSession {
        guard let url = try? XCTUnwrap(URL(string: DataLoaderMocks.mockUrl), "url not valid") else {
            fatalError("Failed to create URL")
        }
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        URLProtocolMock.mockURLs = [URL(string: DataLoaderMocks.mockUrl)!: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    func testLoadData_Success() {
        let dataLoader = DataLoader(session: makeMockSession(data: DataLoaderMocks.mockData.data(using: .utf8), error: nil))
        var actualResult: CountryResponse?
        let expectation = expectation(description: "Data loaded successfully")
        
        dataLoader.loadData(from: DataLoaderMocks.mockUrl, responseType: CountryResponse.self) { result in
            switch result {
            case .success(let result):
                actualResult = result
            case .failure(let error):
                XCTFail("Loading data failed with error: \(error)")
            }
            
            expectation.fulfill()
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
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(actualError)
    }
    
}
