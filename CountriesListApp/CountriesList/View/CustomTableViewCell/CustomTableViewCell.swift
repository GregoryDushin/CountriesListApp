//
//  CustomTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 25.12.2023.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet private var imageLabel: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var capitalLabel: UILabel!
    
    private var imageLoader = ImageLoader()
    private var imageURL: String?
    
    func configure(with country: Country) {
        nameLabel.text = country.name
        descriptionLabel.text = country.descriptionSmall
        capitalLabel.text = country.capital
        imageURL = country.countryInfo.flag
        loadImage()
    }
    
    private func loadImage() {
        guard let imageURL else { return }
        
        imageLoader.loadImage(from: imageURL) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if self.imageURL == imageURL {
                        self.imageLabel.image = image
                    }
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
