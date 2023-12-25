//
//  Extensions.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 25.12.2023.
//

import Foundation

extension URL {
    func replacingScheme(with scheme: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = scheme
        return components?.url ?? self
    }
}
