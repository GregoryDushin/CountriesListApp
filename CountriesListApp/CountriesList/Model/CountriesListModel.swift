//
//  CountriesListModel.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

struct CountryResponse: Decodable {
    let next: String
    let countries: [Country]
}

struct Country: Decodable {
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
}

struct CountryInfo: Decodable {
    let images: [String]
    let flag: String
}
