//
//  Constants.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

enum Url {
    static let countriesUrl = "https://gist.githubusercontent.com/goob0176/4d3056dffc2a18f693cdad8ccc88507e/raw/8e7409cfc35bdb946e2aa93ff44035a8f504bbc3/page_1.json"
}

enum rawsAndSectionsCountryInfoTableView {
    static let numbersOfSection = 3
    static let rawsInHeaderlSection = 1
    static let rawsInDescriptionSection = 1
    static let defaultRaws = 0
    static let headerSection = 0
    static let infoBlockSection = 1
    static let descriptionSection = 2
}

enum Id {
    static let customTableViewCell = String(describing: CustomTableViewCell.self)
    static let countryInfoCollectionViewCell = String(describing: CountryInfoCollectionViewCell.self)
    static let countryInfoTableViewCell = String(describing: CountryInfoTableViewCell.self)
    static let countryDescriptionTableViewCell = String(describing: CountryDescriptionTableViewCell.self)
    static let countryInfoViewController = String(describing: CountryInfoViewController.self)
    static let countryInfoTitleTableViewCell = String(describing: CountryInfoTitleTableViewCell.self)
}

enum CountryInfoImg {
    static let capital = UIImage(systemName: "star") ?? UIImage()
    static let population = UIImage(systemName: "person.fill") ?? UIImage()
    static let continent = UIImage(systemName: "globe.central.south.asia.fill") ?? UIImage()
}

struct L10n {
    static let countriesScreenNavigationItemTitle = NSLocalizedString("Страны", comment: "")
    static let countryCapital = NSLocalizedString("Столица", comment: "")
    static let countryPopulation = NSLocalizedString("Популяция", comment: "")
    static let countryContinent = NSLocalizedString("Континент", comment: "")
    static let countryThirdSectionTitle = NSLocalizedString("О стране", comment: "")
    static let clearButtonTitle = NSLocalizedString("Очистить", comment: "")
    static let formatFetchRequest = NSLocalizedString("name == %@", comment: "")
    static let fetchRequestEntityName = NSLocalizedString("CountryPersistance", comment: "")
}

