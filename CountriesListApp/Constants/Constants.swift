//
//  Constants.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

enum Url {
    static let countriesUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    static let newCountriesUrl = "https://gist.githubusercontent.com/goob0176/4d3056dffc2a18f693cdad8ccc88507e/raw/8e7409cfc35bdb946e2aa93ff44035a8f504bbc3/page_1.json"
}

enum Id {
    static let customTableViewCell = String(describing: CustomTableViewCell.self)
    static let countryInfoCollectionViewCell = String(describing: CountryInfoCollectionViewCell.self)
    static let countryInfoTableViewCell = String(describing: CountryInfoTableViewCell.self)
    static let countryDescriptionTableViewCell = String(describing: CountryDescriptionTableViewCell.self)
    static let countryInfoViewController = String(describing: CountryInfoViewController.self)
}

enum CountryInfoImg {
    static let capital = UIImage(systemName: "star")
    static let population = UIImage(systemName: "person.fill")
    static let continent = UIImage(systemName: "globe.central.south.asia.fill")
}

enum CountryInfoConstants{
    static let capital = "Столица"
    static let population = "Популяция"
    static let continent = "Континент"
}
