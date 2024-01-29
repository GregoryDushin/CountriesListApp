//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import UIKit
import CoreData

class CountriesListPresenter: CountriesListPresenterProtocol {
    
    private struct Constants {
        static let countriesUrl = "https://gist.githubusercontent.com/goob0176/4d3056dffc2a18f693cdad8ccc88507e/raw/8e7409cfc35bdb946e2aa93ff44035a8f504bbc3/page_1.json"
    }
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoader
    private let coreDataManager = CoreDataManager.shared
    var countries: [Country]?
    var error: String?
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func getData() {
        if coreDataManager.hasSavedCountries() {
            loadSavedCountries()
        } else {
            loadDataFromNetwork()
        }
    }
    
    func clearMemory() {
        ImageLoader().clearCache()
        coreDataManager.clearData()
    }
    
    private func loadSavedCountries() {
        let savedCountries = coreDataManager.fetchAllCountries()
        countries = mapToCountryModel(savedCountries)
        view?.success()
    }
    
    private func loadDataFromNetwork() {
        dataLoader.loadData(from: Constants.countriesUrl, responseType: CountryResponse.self) { [weak self] result in
            guard let self else { return }
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
        guard let countries else { return }
        
        countries.forEach { country in
            coreDataManager.saveCountry(from: country)
        }
    }
    
    private func mapToCountryModel(_ countries: [CountryPersistanceObject]) -> [Country] {
        countries.map { countryPersistance in
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
