//
//  CountryInfoCollectionViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var countryImage: UIImageView!
    
    private var imageLoader: ImageLoader?
    private var imageURL: String?
    
    func configure(with country: Country, imageLoader: ImageLoader, indexPath: Int) {
        if country.countryInfo.images.isEmpty {
            imageURL = country.countryInfo.flag
        } else {
            imageURL = country.countryInfo.images[indexPath]
        }
        
        self.imageLoader = imageLoader
        loadImage()
    }
    
    private func loadImage() {
        guard let imageURL, let imageLoader else { return }
        
        imageLoader.loadImage(from: imageURL) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if self.imageURL == imageURL {
                        self.countryImage.image = image
                    }
                }
            case .failure(let error):
                
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
