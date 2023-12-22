//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

final class CountriesListPresenter: CountriesListPresenterProtocol {

    weak var view: CountriesListProtocol?
    private let countryLoader: CountryLoaderProtocol

    init(countryLoader: CountryLoaderProtocol) {
        self.countryLoader = countryLoader
    }

    func getData() {
        countryLoader.countryDataLoad { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.view?.success(data: countries)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}

