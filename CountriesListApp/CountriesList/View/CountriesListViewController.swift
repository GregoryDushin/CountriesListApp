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
        self.presenter?.view = self
        self.presenter?.getData()
    }

    private func printTest() {
        print(countries)
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}

extension CountriesListViewController: CountriesListProtocol {

    func success(data: [Country]) {
        self.countries = data
        self.printTest()
    }

    func failure(error: Error) {
        self.showAlert(error.localizedDescription)
    }
}
