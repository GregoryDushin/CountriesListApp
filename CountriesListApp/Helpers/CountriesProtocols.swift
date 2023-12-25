//
//  CountriesProtocols.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 22.12.2023.
//

import Foundation
import UIKit

protocol DataLoadable {
    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void)
}

protocol CountriesListProtocol: AnyObject {
    func success(data: [Country], img: [UIImage])
    func failure(error: Error)
}

protocol CountriesListPresenterProtocol: AnyObject {
    func getData(completion: @escaping () -> Void)
    var view: CountriesListProtocol? { get set }
}

protocol ImageLoadable {
    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
