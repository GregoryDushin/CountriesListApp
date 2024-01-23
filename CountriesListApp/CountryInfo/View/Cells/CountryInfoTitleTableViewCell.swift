//
//  CountryInfoTitleTableViewCell.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 17.01.2024.
//

import UIKit

final class CountryInfoTitleTableViewCell: UITableViewCell {

    @IBOutlet private var headerLabel: UILabel!
    
    func configure(header: String) {
        headerLabel.text = header
    }
}
