//
//  ViewControllerFactory.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 17.01.2024.
//

import Foundation


struct ViewControllerFactory {
    static func createCountriesVC() -> CountriesListViewController {
        let countriesViewController = CountriesListViewController()
        countriesViewController.presenter = CountriesListPresenter(dataLoader: DataLoader())
        return countriesViewController
    }
    static func createCountryInfoVC(country: Country) -> CountryInfoViewController {
        let countryInfoViewController = CountryInfoViewController(nibName: Id.countryInfoViewController, bundle: nil)
        countryInfoViewController.presenter = CountryInfoPresenter(country: country)
        return countryInfoViewController
    }
}
