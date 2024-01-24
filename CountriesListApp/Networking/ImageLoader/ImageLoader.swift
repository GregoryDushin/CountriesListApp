//
//  ImageLoader.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 25.12.2023.
//

import Foundation
import UIKit

final class ImageLoader: ImageLoadable {
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completion(.failure(LoaderError.unsuppotedURL))
            return
        }
        
        let task = session.dataTask(with: imageURL) { [weak self] data, _, error in
            guard let self else { return }
            guard let data else {
                completion(.failure(error ?? LoaderError.networkRequestFailed))
                return
            }
            
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            } else {
                completion(.failure(LoaderError.invalidImageData))
            }
        }
        task.resume()
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
