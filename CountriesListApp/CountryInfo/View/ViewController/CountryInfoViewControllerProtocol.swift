//
//  CountryInfoViewControllerProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 14.01.2024.
//

import Foundation

protocol CountryInfoProtocol: AnyObject {
    func success(data: [CountryInfoModel], data2: Country )
    func failure(error: Error)
}
