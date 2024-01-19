//
//  Utils.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 17.01.2024.
//

import UIKit

class Utils {
    static func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
