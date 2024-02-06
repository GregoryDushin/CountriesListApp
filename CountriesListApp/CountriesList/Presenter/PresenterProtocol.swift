//
//  PresenterProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 05.01.2024.
//

import Foundation

protocol CountriesListPresenterProtocol: AnyObject {
    func getData()
    var view: CountriesListProtocol? { get set }
    var isLoadingData: Bool { get set }
}
