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
    
    private var imgs: [UIImage] = []
    private var countries: [Country] = []
    
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
        view.addSubview(tableView)
    }
    
    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

// MARK: - CountriesListProtocol

extension CountriesListViewController: CountriesListProtocol {
    func success(data: [Country], img: [UIImage]) {
        countries = data
        imgs = img
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failure(error: Error) {
        showAlert(error.localizedDescription)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.customTableViewCell, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let country = countries[indexPath.row]
        cell.configure(with: country, imageLoader: ImageLoader())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
