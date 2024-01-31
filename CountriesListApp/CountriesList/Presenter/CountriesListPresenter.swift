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
        static let countriesUrl = "https://gist.githubusercontent.com/goob0176/4d3056dffc2a18f693cdad8ccc88507e/raw/adf6052f156b72c112f7e43ff2ed434a8440d452/page_1.json"
        
        static let nextCountriesUrl = "https://gist.githubusercontent.com/goob0176/9591ef78855c7e3eb80a71ff59657ebc/raw/af6b58149ca64855719a74686c5eafdcd3dae96a/page_2.json"
    }
    
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoader
    private let coreDataManager = CoreDataManager.shared
    private var nextPageUrl: String?
    var countries: [Country]?
    var error: String?
    var isLoadingData: Bool = false
    
    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
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
    }
    
    func loadNextPage() {
        guard let nextUrl = nextPageUrl else {
            return
        }
        
        DispatchQueue.main.async {
            self.isLoadingData = true
            self.loadDataFromNetwork(from: nextUrl)
        }
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
                    
//                    if !data.next.isEmpty {
//                        self.nextPageUrl = Constants.nextCountriesUrl
//                    }
                    
                    if let existingCountries = self.countries {
                        self.countries = existingCountries + data.countries
                    } else {
                        self.countries = data.countries
                    }
                    
                    self.saveCountriesToCoreData()
                    self.view?.success()
                case .failure(let error):
                    self.error = error.localizedDescription
                    print(error.localizedDescription)
                    self.view?.failure()
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
