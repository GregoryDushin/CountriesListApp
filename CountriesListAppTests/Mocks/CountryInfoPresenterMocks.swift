//
//  CountryInfoPresenterMocks.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 12.02.2024.
//

import XCTest
@testable import CountriesListApp

final class CountryInfoPresenterMocks {
    
    static let mockCountry = Country(
        name: "Test Country",
        continent: "Test Continent",
        capital: "Test Capital",
        population: 1000000,
        descriptionSmall: "Test Description Small",
        description: "Test Description",
        image: "Test Img", countryInfo:
            CountryInfo(images: ["Test Image 1", "Test Image 2"],
                        flag: "Test Flag")
    )
    
}

final class MockCountryInfoView: CountryInfoProtocol {
    var presented = false
    
    func present() {
        presented = true
    }
}
