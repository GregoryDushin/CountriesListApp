//
//  CountriesListViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

final class CountriesListViewController: UIViewController {
    
    var presenter: CountriesListPresenter?
    weak var coordinatorDelegate: CountriesListCoordinator?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib(nibName: Id.customTableViewCell, bundle: nil), forCellReuseIdentifier: Id.customTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        presenter?.getData()
        navigationItem.title = L10n.countriesScreenNavigationItemTitle
        view.addSubview(tableView)
    }
}

// MARK: - CountriesListProtocol

extension CountriesListViewController: CountriesListProtocol {
    
    func success() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func failure() {
        if let presenter = presenter , let presenterError = presenter.error {
            Utils.showAlert(on: self, message: presenterError)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter = presenter, let countries = presenter.countries {
            return countries.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.customTableViewCell, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        if let presenter = presenter, let countries = presenter.countries {
            let country = countries[indexPath.row]
            cell.configure(with: country, imageLoader: ImageLoader())
            return cell
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let presenter = presenter, let countries = presenter.countries {
            let selectedCountry = countries[indexPath.row]
            coordinatorDelegate?.didSelectCountry(selectedCountry)
        }
    }
}
