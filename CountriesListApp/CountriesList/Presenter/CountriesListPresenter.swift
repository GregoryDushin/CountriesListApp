//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import UIKit
import CoreData

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
                self.saveCountriesToCoreData()
                self.view?.success()
            case .failure(let error):
                self.error = error.localizedDescription
                self.view?.failure()
            }
        }
    }

    private func saveCountriesToCoreData() {
            guard let countries = countries else { return }
            
            for country in countries {
                CoreDataManager.shared.saveCountry(
                    name: country.name,
                    continent: country.continent,
                    capital: country.capital,
                    population: Int64(country.population),
                    descriptionSmall: country.descriptionSmall,
                    descriptionFull: country.description
                )
            }
        }
    }

