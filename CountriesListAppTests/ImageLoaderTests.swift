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
    
    func testLoadImage_Success() {
        
        let expectation = self.expectation(description: "Loading image")
        
        let imageLoader = ImageLoader(session: makeMockSession(data: ImageLoadersMocks.mockImage.pngData(), error: nil))
        
        imageLoader.loadImage(from: "https://test.com") { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected successful image loading, but got error: \(error)")
            }
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
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    private func makeMockSession(data: Data?, error: Error?) -> URLSession {
        TestDataLoader.makeMockSession(data: data, error: error, for: DataLoaderMocks.mockUrl)
    }
}
