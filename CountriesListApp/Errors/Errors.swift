//
//  Errors.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 05.01.2024.
//

import Foundation

enum LoaderError: Error {
    case networkRequestFailed
    case unsuppotedURL
    case invalidImageData
    case dataFailed
}
