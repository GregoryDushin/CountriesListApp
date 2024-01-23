//
//  Coordinator.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 19.01.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func didSelectCountry(_ country: Country)
}

final class CountriesListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let countriesVC = ViewControllerFactory.createCountriesVC()
        countriesVC.coordinatorDelegate = self
        navigationController.pushViewController(countriesVC, animated: true)
    }
    
    func didSelectCountry(_ country: Country) {
        let countryInfoVC = ViewControllerFactory.createCountryInfoVC(country: country)
        navigationController.pushViewController(countryInfoVC, animated: true)
    }
}


