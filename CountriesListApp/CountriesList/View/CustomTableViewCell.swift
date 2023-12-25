//
//  CustomTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 25.12.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    
    func configure(with country: Country, image: UIImage?) {
            nameLabel.text = country.name
            descriptionLabel.text = country.descriptionSmall
            capitalLabel.text = country.capital
            imageLabel.image = image
        }
}
