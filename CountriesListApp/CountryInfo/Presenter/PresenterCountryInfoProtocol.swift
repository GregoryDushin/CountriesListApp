//
//  PresenterCountryInfoProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 14.01.2024.
//

import Foundation

protocol CountryInfoPresenterProtocol: AnyObject {
    func getData()
    var view: CountryInfoProtocol? { get set }
}
