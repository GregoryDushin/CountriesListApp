//
//  MockUrl.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 06.02.2024.
//

@testable import CountriesListApp
import Foundation

final class DataLoaderMocks {
    
    static let mockData = """
{
            "next":"test_url",
            "countries":[
                {
                    "name": "test_name",
                    "continent": "test_continent",
                    "capital":"test_capital",
                    "population" : 123 ,
                    "description_small": "test_description_small",
                    "description": "test_description",
                    "country_info": {
                        "images":[],
                        "flag": "test_flag"
                    }
                }
]
}
"""
    
    static let expectedResult = CountryResponse(
        next: "test_url",
        countries: [Country(
            name: "test_name",
            continent: "test_continent",
            capital: "test_capital",
            population: 123,
            descriptionSmall: "test_description_small",
            description: "test_description",
            image: nil,
            countryInfo: CountryInfo(images: [], flag: "test_flag")
        )
        ]
    )
    
    static let mockUrl = "https://test.com"
}

final class URLProtocolMock: URLProtocol {
    
    static var mockURLs = [
        URL?: (
            error: Error?,
            data: Data?,
            response: HTTPURLResponse?)
    ]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                
                if let response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                if let error {
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
