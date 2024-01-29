//
//  CountryDescriptionTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryDescriptionTableViewCell: UITableViewCell {
    
    private struct Constants {
        static let countryThirdSectionTitle = "О стране"
    }
    
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var aboutLabel: UILabel!
    
    func configure(description: String) {
        descriptionLabel.text = description
        aboutLabel.text = Constants.countryThirdSectionTitle
    }
}
