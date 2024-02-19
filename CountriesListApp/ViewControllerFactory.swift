//
//  ViewControllerFactory.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 17.01.2024.
//

import Foundation


struct ViewControllerFactory {
    
    private struct Constants {
        static let countryInfoViewController = String(describing: CountryInfoViewController.self)
    }
    
    static func createCountriesVC() -> CountriesListViewController {
        let countriesViewController = CountriesListViewController(coreDataManager: CoreDataManager.shared)
        countriesViewController.presenter = CountriesListPresenter(
            dataLoader: DataLoader(), 
            coreDataManager: CoreDataManager.shared
        )
        return countriesViewController
    }
    static func createCountryInfoVC(country: Country) -> CountryInfoViewController {
        let countryInfoViewController = CountryInfoViewController(nibName: Constants.countryInfoViewController, bundle: nil)
        countryInfoViewController.presenter = CountryInfoPresenter(country: country)
        return countryInfoViewController
    }
}
