//
//  DataLoaderProtocol.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 05.01.2024.
//

import Foundation

protocol DataLoadable {
    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void)
}
