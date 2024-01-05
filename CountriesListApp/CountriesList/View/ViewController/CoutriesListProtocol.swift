//
//  CoutriesListProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 05.01.2024.
//

import UIKit
import Foundation

protocol CountriesListProtocol: AnyObject {
    func success(data: [Country], img: [UIImage])
    func failure(error: Error)
}
