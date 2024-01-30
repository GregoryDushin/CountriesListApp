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

    public static var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = ImageLoader.imageCache.object(forKey: url as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completion(.failure(LoaderError.unsuppotedURL))
            return
        }
        
        let task = session.dataTask(with: imageURL) { data, _, error in
            guard let data else {
                completion(.failure(error ?? LoaderError.networkRequestFailed))
                return
            }
            
            if let image = UIImage(data: data) {
                ImageLoader.imageCache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            } else {
                completion(.failure(LoaderError.invalidImageData))
            }
        }

        task.resume()
    }

    public static func clearCache() {
        ImageLoader.imageCache.removeAllObjects()
    }
}
