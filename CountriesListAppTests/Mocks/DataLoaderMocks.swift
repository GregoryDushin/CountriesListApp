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
""".data(using: .utf8)!
    
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

final class MockURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
