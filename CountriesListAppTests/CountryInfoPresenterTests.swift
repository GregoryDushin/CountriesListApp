//
//  CountryInfoPresenterTests.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 12.02.2024.
//

import XCTest
@testable import CountriesListApp

final class CountryInfoPresenterTests: XCTestCase {
    
    var presenter: CountryInfoPresenter!
    var mockCountry: Country!
    var mockView: MockCountryInfoView!
    
    override func setUp() {
        super.setUp()
        
        mockCountry = CountryInfoPresenterMocks.mockCountry
        mockView = MockCountryInfoView()
        presenter = CountryInfoPresenter(country: mockCountry)
        presenter.view = mockView
    }
    
    override func tearDown() {
        presenter = nil
        mockCountry = nil
        mockView = nil
        super.tearDown()
    }
    
    func testGetData_Presented() {
        presenter.getData()
        XCTAssertTrue(mockView.presented)
        XCTAssertNotNil(presenter.countryInfoArray)
        XCTAssertEqual(presenter.countryInfoArray?.count, 3)
    }
}
