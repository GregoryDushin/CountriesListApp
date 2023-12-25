//
//  Constants.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

enum Url {
    static let countriesUrl = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
}

enum LoaderError: Error {
    case networkRequestFailed
    case unsuppotedURL
    case invalidImageData
}
