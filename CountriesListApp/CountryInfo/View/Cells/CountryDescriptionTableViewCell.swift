//
//  CountryDescriptionTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryDescriptionTableViewCell: UITableViewCell {
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var aboutLabel: UILabel!
    
    func configure(description: String) {
        descriptionLabel.text = description
        aboutLabel.text = L10n.countryThirdSectionTitle
    }
}
