//
//  ImageLoaderTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 12.02.2024.
//

import XCTest
@testable import CountriesListApp

final class ImageLoaderTests: XCTestCase {
    
    var imageLoader: ImageLoader!
    var mockSession: URLSession!
    
    private func makeMockSession(data: Data?, error: Error?) -> URLSession {
        guard let url = try? XCTUnwrap(URL(string: "https://test.com"), "URL is not valid") else {
            fatalError("Failed to create URL")
        }
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        URLProtocolMock.mockURLs = [url: (error, data, response)]
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        
        return URLSession(configuration: sessionConfiguration)
    }
    
    func testLoadImage_Success() {
        
        let expectation = self.expectation(description: "Loading image")
        
        let imageLoader = ImageLoader(session: makeMockSession(data: ImageLoadersMocks.mockImage.pngData(), error: nil))
        
        imageLoader.loadImage(from: "https://test.com") { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure(let error):
                XCTFail("Expected successful image loading, but got error: \(error)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImage_Failure() {
        
        let expectation = self.expectation(description: "Loading failed")
        
        let imageLoader = ImageLoader(session: makeMockSession(data: nil, error: LoaderError.dataFailed))
        
        imageLoader.loadImage(from: "https://test.com") { result in
            switch result {
            case .success:
                XCTFail("Expected failed image loading, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
