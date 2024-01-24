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
        if CoreDataManager.shared.hasSavedCountries() {
            loadSavedCountries()
        } else {
            loadDataFromNetwork()
        }
    }
    
    func clearMemory() {
        ImageLoader().clearCache()
        CoreDataManager.shared.clearData()
    }
    
    private func loadSavedCountries() {
        let savedCountries = CoreDataManager.shared.fetchAllCountries()
        self.countries = mapToCountryModel(savedCountries)
        self.view?.success()
    }
    
    private func loadDataFromNetwork() {
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
                descriptionFull: country.description,
                images: country.countryInfo.images,
                flag: country.countryInfo.flag
            )
        }
    }
    
    private func mapToCountryModel(_ countries: [CountryPersistance]) -> [Country] {
        return countries.map { countryPersistance in
            Country(
                name: countryPersistance.name,
                continent: countryPersistance.continent,
                capital: countryPersistance.capital,
                population: Int(countryPersistance.population),
                descriptionSmall: countryPersistance.descriptionSmall,
                description: countryPersistance.descriptionFull,
                image: nil,
                countryInfo: CountryInfo(
                    images: countryPersistance.images,
                    flag: countryPersistance.flag
                )
            )
        }
    }
}
