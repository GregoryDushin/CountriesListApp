//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import UIKit
import CoreData

final class CountriesListPresenter: CountriesListPresenterProtocol {
    
    private struct Constants {
        static let countriesUrl = "https://gist.githubusercontent.com/goob0176/4d3056dffc2a18f693cdad8ccc88507e/raw/a29905f5352a99a5b83904ba6f40313fb41a5ca2/page_1.json"
    }
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoadable
    var coreDataManager: CoreDataManagerProtocol
    var nextPageUrl: String?
    private(set) var countries: [Country]?
    private(set) var error: String?
    var isLoadingData: Bool = false
    
    init(dataLoader: DataLoadable, coreDataManager: CoreDataManagerProtocol ) {
        self.dataLoader = dataLoader
        self.coreDataManager = coreDataManager
    }
    
    func getData() {
        if coreDataManager.hasSavedCountries() {
            loadSavedCountries()
        } else {
            loadDataFromNetwork(from: Constants.countriesUrl)
        }
    }
    
    func clearMemory() {
        ImageLoader.clearCache()
        coreDataManager.clearData()
        countries = []
    }
    
    func loadNextPage() {
        guard let nextUrl = nextPageUrl else {
            self.error = LoaderError.loadNextPageFailed.localizedDescription
            self.view?.failure()
            return
        }
        
        self.isLoadingData = true
        self.view?.showLoadingIndicator(true)
        self.loadDataFromNetwork(from: nextUrl)
    }
    
    private func loadSavedCountries() {
        let savedCountries = coreDataManager.fetchAllCountries()
        countries = mapToCountryModel(savedCountries)
        view?.success()
    }
    
    private func loadDataFromNetwork(from url: String) {
        dataLoader.loadData(from: url, responseType: CountryResponse.self) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.nextPageUrl = data.next
                    if let existingCountries = self.countries {
                        self.isLoadingData = true
                        self.countries = existingCountries + data.countries
                    } else {
                        self.isLoadingData = false
                        self.countries = data.countries
                    }
                    
                    self.saveCountriesToCoreData()
                    self.view?.success()
                    self.view?.showLoadingIndicator(false)
                case .failure(let error):
                    self.error = error.localizedDescription
                    self.view?.failure()
                    self.view?.showLoadingIndicator(false)
                }
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
        countries.map { Country.mapToCountryModel($0) }
    }
}


