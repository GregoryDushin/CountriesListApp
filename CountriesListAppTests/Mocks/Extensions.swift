//
//  Extensions.swift
//  CountriesListAppTests
//
//  Created by Григорий Душин on 07.02.2024.
//

@testable import CountriesListApp
import Foundation

extension CountryResponse: Equatable {
    public static func == (lhs: CountryResponse, rhs: CountryResponse) -> Bool {
        lhs.next == rhs.next && lhs.countries == rhs.countries
    }
}

extension Country: Equatable {
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name == rhs.name &&
        lhs.continent == rhs.continent &&
        lhs.capital == rhs.capital &&
        lhs.population == rhs.population &&
        lhs.descriptionSmall == rhs.descriptionSmall &&
        lhs.description == rhs.description &&
        lhs.image == rhs.image &&
        lhs.countryInfo == rhs.countryInfo
    }
}

extension CountryInfo: Equatable {
    public static func == (lhs: CountryInfo, rhs: CountryInfo) -> Bool {
        lhs.images == rhs.images &&
        lhs.flag == rhs.flag
    }
}
