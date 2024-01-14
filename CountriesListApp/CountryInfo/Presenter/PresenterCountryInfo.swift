//
//  PresenterCountryInfo.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import Foundation
import UIKit

final class CountryInfoPresenter: CountryInfoPresenterProtocol {
    var view: CountryInfoProtocol?
    var countryInfo: Country
    
    init(country: Country) {
        self.countryInfo = country
    }
    
    func getData() {
        let capitalInfo = CountryInfoModel(
            image: CountryInfoImg.capital!,
            labelFixed: CountryInfoConstants.capital,
            labelText: countryInfo.capital)
        let populationInfo = CountryInfoModel(
            image: CountryInfoImg.population!,
            labelFixed: CountryInfoConstants.population,
            labelText: String(countryInfo.population))
        let continentInfo = CountryInfoModel(
            image: CountryInfoImg.continent!,
            labelFixed: CountryInfoConstants.continent,
            labelText: countryInfo.continent)
        
        self.view?.success(data: [capitalInfo, populationInfo, continentInfo], data2: countryInfo)
    }
}
