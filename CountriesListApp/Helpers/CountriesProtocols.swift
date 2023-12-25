//
//  CountriesProtocols.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 22.12.2023.
//

import Foundation

protocol DataLoadable {
    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void)
}

protocol CountriesListProtocol: AnyObject {
    func success(data: [Country])
    func failure(error: Error)
}

protocol CountriesListPresenterProtocol: AnyObject {
    func getData()
    var view: CountriesListProtocol? { get set }
}
