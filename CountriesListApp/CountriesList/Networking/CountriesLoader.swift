//
//  CountriesLoader.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation

// MARK: Universal Loader

final class DataLoader: DataLoadable {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func loadData<ResultType: Decodable>(from url: String, responseType: ResultType.Type, completion: @escaping (Result<ResultType, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(LoaderError.unsuppotedURL))
            return
        }

        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? LoaderError.networkRequestFailed))
                return
            }

            do {
                let item = try self.decoder.decode(responseType, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
