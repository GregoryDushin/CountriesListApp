//
//  CountryInfoTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryInfoTableViewCell: UITableViewCell {
    @IBOutlet private var imageInfo: UIImageView!
    @IBOutlet private var constantLabel: UILabel!
    @IBOutlet private var infoLabel: UILabel!
    
    func configure(constantText: String, infoText: String, image: UIImage) {
        let templateImage = image.withRenderingMode(.alwaysTemplate)
        imageInfo.image = templateImage
        imageInfo.tintColor = UIColor.orange
        constantLabel.text = constantText
        infoLabel.text = infoText
    }
}
