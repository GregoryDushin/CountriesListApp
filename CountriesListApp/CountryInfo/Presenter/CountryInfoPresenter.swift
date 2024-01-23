//
//  CountryInfoPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import Foundation
import UIKit

final class CountryInfoPresenter: CountryInfoPresenterProtocol {
    weak var view: CountryInfoProtocol?
    var country: Country
    var countryInfoArray : [CountryInfoModel]?
    
    init(country: Country) {
        self.country = country
    }
    
    func getData() {
            let capitalInfo = CountryInfoModel(
                image: CountryInfoImg.capital,
                labelFixed: L10n.countryCapital,
                labelText: country.capital)
            let populationInfo = CountryInfoModel(
                image: CountryInfoImg.population,
                labelFixed: L10n.countryPopulation,
                labelText: String(country.population))
            let continentInfo = CountryInfoModel(
                image: CountryInfoImg.continent,
                labelFixed: L10n.countryContinent,
                labelText: country.continent)
            
            self.countryInfoArray = [capitalInfo, populationInfo, continentInfo]
            
            self.view?.present()
    }
}
