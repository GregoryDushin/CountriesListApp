//
//  CountriesLoader.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

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
        guard let url else { return }

        let task = session.dataTask(with: url) { data, _, error in
            guard let data else { return }
            
            do {
                let json = try self.decoder.decode(CountryResponse.self, from: data)
                let countries = json.countries
                completion(.success(countries))

            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
