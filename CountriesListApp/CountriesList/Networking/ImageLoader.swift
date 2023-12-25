//
//  ImageLoader.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 25.12.2023.
//

import Foundation
import UIKit

// MARK: Universal Image Loader


final class ImageLoader: ImageLoadable {
    private let session = URLSession.shared

    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(LoaderError.unsuppotedURL))
            return
        }

        var secureURL = url
        if url.scheme == "http" {
            secureURL = url.replacingScheme(with: "https")
        }

        let task = session.dataTask(with: secureURL) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? LoaderError.networkRequestFailed))
                return
            }

            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(LoaderError.invalidImageData))
            }
        }
        task.resume()
    }
}
