//
//  CountriesListModel.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

struct CountryResponse: Decodable, Equatable {
    let next: String
    let countries: [Country]
    
    static func == (lhs: CountryResponse, rhs: CountryResponse) -> Bool {
        return lhs.next == rhs.next && lhs.countries == rhs.countries
    }
}

struct Country: Decodable, Equatable {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let descriptionSmall: String
    let description: String
    let image: String?
    let countryInfo: CountryInfo
    
    static func mapToCountryModel(_ countryPersistance: CountryPersistanceObject) -> Country {
        return Country(
            name: countryPersistance.name,
            continent: countryPersistance.continent,
            capital: countryPersistance.capital,
            population: Int(countryPersistance.population),
            descriptionSmall: countryPersistance.descriptionSmall,
            description: countryPersistance.descriptionFull,
            image: nil,
            countryInfo: CountryInfo(
                images: countryPersistance.images,
                flag: countryPersistance.flag
            )
        )
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name &&
        lhs.continent == rhs.continent &&
        lhs.capital == rhs.capital &&
        lhs.population == rhs.population &&
        lhs.descriptionSmall == rhs.descriptionSmall &&
        lhs.description == rhs.description &&
        lhs.image == rhs.image &&
        lhs.countryInfo == rhs.countryInfo
    }
}

struct CountryInfo: Decodable, Equatable {
    let images: [String]
    let flag: String
    
    static func == (lhs: CountryInfo, rhs: CountryInfo) -> Bool {
        return lhs.images == rhs.images &&
        lhs.flag == rhs.flag
    }
}
