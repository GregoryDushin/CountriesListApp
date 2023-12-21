//
//  CountriesLoader.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

protocol CountryLoaderProtocol {
    func countryDataLoad(completion: @escaping (Result<[Country], Error>) -> Void)
}

final class CountryLoader: CountryLoaderProtocol {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func countryDataLoad(completion: @escaping (Result<[Country], Error>) -> Void) {
        loadCountryData(url: URL(string: Url.countriesUrl), completion: completion)
    }
    
    private func loadCountryData(url: URL?, completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = url else { return }

        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let json = try self.decoder.decode(CountryResponse.self, from: data)
                let countries = json.countries
                completion(.success(countries))
                
                if let nextURL = URL(string: json.next) {
                    self.loadCountryData(url: nextURL, completion: completion)
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
