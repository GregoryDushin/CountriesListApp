//
//  CountriesListViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

final class CountriesListViewController: UIViewController {

    var presenter: CountriesListPresenterProtocol?

    private var countries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        presenter?.getData()
    }

    private func printCountryTest() {
        print(countries)
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

extension CountriesListViewController: CountriesListProtocol {
    func success(data: [Country]) {
        countries = data
        printCountryTest()
    }
    
    func failure(error: Error) {
        showAlert(error.localizedDescription)
        print(error.localizedDescription)
    }
}
