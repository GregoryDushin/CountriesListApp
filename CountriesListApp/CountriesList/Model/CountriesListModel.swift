//
//  CountriesListModel.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

struct CountryResponse: Codable {
    let next: String
    let countries: [Country]
}

struct Country: Codable {
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let descriptionSmall: String
    let description: String
    let image: String?
    let countryInfo: CountryInfo
}

struct CountryInfo: Codable {
    let images: [String]
    let flag: String
}
