//
//  PresenterCountryInfo.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import Foundation
import UIKit

protocol CountryInfoProtocol: AnyObject {
    func success(data: Country)
    func failure(error: Error)
}

protocol CountryInfoPresenterProtocol: AnyObject {
    func getData()
    var view: CountryInfoProtocol? { get set }
}

final class CountryInfoPresenter: CountryInfoPresenterProtocol {
    var view: CountryInfoProtocol?
    
    var countryInfo: Country
    
    init(country: Country) {
        self.countryInfo = country
    }
    
    func getData() {
        self.view?.success(data: countryInfo)
    }
}
