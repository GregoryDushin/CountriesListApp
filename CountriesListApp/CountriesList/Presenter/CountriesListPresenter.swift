//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

class CountriesListPresenter: CountriesListPresenterProtocol {
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoader
    var countries: [Country]?
    var error: String?
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func getData() {
        dataLoader.loadData(from: Url.countriesUrl, responseType: CountryResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.countries = data.countries
                self.view?.success()
            case .failure(let error):
                self.error = error.localizedDescription
                self.view?.failure()
            }
        }
    }
}
