//
//  CountriesListPresenter.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

//final class CountriesListPresenter: CountriesListPresenterProtocol {
//
//    weak var view: CountriesListProtocol?
//    private let countryLoader: CountryLoaderProtocol
//
//    init(countryLoader: CountryLoaderProtocol) {
//        self.countryLoader = countryLoader
//    }
//
//    func getData() {
//        countryLoader.countryDataLoad { [weak self] result in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let countries):
//                    self.view?.success(data: countries)
//                case .failure(let error):
//                    self.view?.failure(error: error)
//                }
//            }
//        }
//    }
//}

// MARK: Presenter with universal Loader

protocol CountriesListProtocol: AnyObject {
    associatedtype DataType: Decodable
    func success(data: [DataType])
    func failure(error: Error)
}

protocol CountriesListPresenterProtocol: AnyObject {
    associatedtype DataType: Decodable
    var view: (any CountriesListProtocol)? { get set }
    func getData()
}

final class CountriesListPresenter<T: Decodable>: CountriesListPresenterProtocol {
    typealias DataType = T
    
    weak var view: (any CountriesListProtocol)?
    private let dataLoader: any DataLoadable
    
    init(dataLoader: any DataLoadable) {
        self.dataLoader = dataLoader
    }
    func getData() {
           dataLoader.loadData { [weak self] result in
               //Member 'loadData' cannot be used on value of type 'any DataLoadable'; consider using a generic constraint instead
               guard let self = self else { return }
               DispatchQueue.main.async {
                   switch result {
                   case .success(let data):
                       self.view?.success(data: data)
                       //Cannot convert value of type '[any Swift.Decodable]' to expected argument type '[any Swift.Decodable]'
                   case .failure(let error):
                       self.view?.failure(error: error)
                   }
               }
           }
       }
   }
