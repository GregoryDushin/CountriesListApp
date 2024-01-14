//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

final class CountriesListPresenter: CountriesListPresenterProtocol {
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoader
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func getData() {
        dataLoader.loadData(from: Url.newCountriesUrl, responseType: CountryResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            var countries: [Country] = []
            
            switch result {
            case .success(let data):
                countries = data.countries
            case .failure(let error):
                self.view?.failure(error: error)
            }
            
            self.view?.success(data: countries, img: [])
        }
    }
}
