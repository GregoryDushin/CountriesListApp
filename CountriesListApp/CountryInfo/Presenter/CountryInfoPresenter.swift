//
//  CountryInfoPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import Foundation
import UIKit

final class CountryInfoPresenter: CountryInfoPresenterProtocol {
    
    private struct Constants {
        struct CountryInfoImg {
            static let capital = UIImage(systemName: "star") ?? UIImage()
            static let population = UIImage(systemName: "person.fill") ?? UIImage()
            static let continent = UIImage(systemName: "globe.central.south.asia.fill") ?? UIImage()
        }

        struct CountryInfolabelFixed {
            static let countryCapital = "Столица"
            static let countryPopulation = "Популяция"
            static let countryContinent = "Континент"
        }
    }
    
    weak var view: CountryInfoProtocol?
    var country: Country
    var countryInfoArray : [CountryInfoModel]?
    
    init(country: Country) {
        self.country = country
    }
    
    func getData() {
        let capitalInfo = CountryInfoModel(
            image: Constants.CountryInfoImg.capital,
            labelFixed: Constants.CountryInfolabelFixed.countryCapital,
            labelText: country.capital)
        let populationInfo = CountryInfoModel(
            image: Constants.CountryInfoImg.population,
            labelFixed: Constants.CountryInfolabelFixed.countryPopulation,
            labelText: String(country.population))
        let continentInfo = CountryInfoModel(
            image: Constants.CountryInfoImg.continent,
            labelFixed: Constants.CountryInfolabelFixed.countryContinent,
            labelText: country.continent)
        
        self.countryInfoArray = [capitalInfo, populationInfo, continentInfo]
        
        self.view?.present()
    }
}
