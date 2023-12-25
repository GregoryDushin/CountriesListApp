//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

// MARK: Presenter with universal Loader

final class CountriesListPresenter: CountriesListPresenterProtocol {
    
    weak var view: CountriesListProtocol?
    private let dataLoader: DataLoader
    private let imageLoader: ImageLoader
    
    init(dataLoader: DataLoader, imageLoader: ImageLoader) {
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
    }
    
    func getData(completion: @escaping () -> Void) {
        dataLoader.loadData(from: Url.countriesUrl, responseType: CountryResponse.self) { [weak self] result in
            guard let self = self else { return }

            var countriesFlags: [UIImage] = []
            var countries: [Country] = []

            let dispatchGroup = DispatchGroup()

            switch result {
            case .success(let data):
                countries = data.countries

                for country in countries {
                    dispatchGroup.enter()

                    self.imageLoader.loadImage(from: country.countryInfo.flag) { imageResult in
                        switch imageResult {
                        case .success(let image):
                            countriesFlags.append(image)
                            print("Test loaded image for \(country.name)")
                        case .failure(let error):
                            print("Failed to load image for \(country.name): \(error.localizedDescription)")
                        }

                        dispatchGroup.leave()
                    }
                }

            case .failure(let error):
                self.view?.failure(error: error)
            }

            dispatchGroup.notify(queue: .main) {
                self.view?.success(data: countries, img: countriesFlags)
                completion()
            }
        }
    }
}
