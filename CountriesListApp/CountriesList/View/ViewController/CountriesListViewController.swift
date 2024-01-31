//
//  CountriesListViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

final class CountriesListViewController: UIViewController {
    
    private struct Constants {
        struct Id {
            static let customTableViewCell = String(describing: CustomTableViewCell.self)
        }
        
        struct UI {
            static let countriesScreenNavigationItemTitle = "Страны"
            static let clearButtonTitle = "Очистить"
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    var presenter: CountriesListPresenter?
    weak var coordinatorDelegate: CountriesListCoordinator?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib(nibName: Constants.Id.customTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.customTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    var isLoadingData: Bool {
        return presenter?.isLoadingData ?? false
    }
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createClearButton()
        setupPullToRefresh()
        presenter?.view = self
        presenter?.getData()
        navigationItem.title = Constants.UI.countriesScreenNavigationItemTitle
        view.addSubview(tableView)
        
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateClearButtonStyle()
    }
    
    // MARK: - UI Actions
    
    private func updateClearButtonStyle() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func createClearButton() {
        let clearButton = UIBarButtonItem(
            title: Constants.UI.clearButtonTitle,
            style: .plain,
            target: self,
            action: #selector(clearButtonTapped)
        )
        navigationItem.rightBarButtonItem = clearButton
    }
    
    @objc private func clearButtonTapped() {
        presenter?.clearMemory()
    }
    
    // MARK: - Pull to Refresh
        
        private func setupPullToRefresh() {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }

        @objc private func refreshData() {
            presenter?.clearMemory()
            presenter?.getData()
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
        if let presenter, let presenterError = presenter.error {
            Utils.showAlert(on: self, message: presenterError)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter, let countries = presenter.countries {
            return countries.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.customTableViewCell, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        if let presenter, let countries = presenter.countries {
            let country = countries[indexPath.row]
            cell.configure(with: country)
            return cell
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let presenter, let countries = presenter.countries {
            let selectedCountry = countries[indexPath.row]
            coordinatorDelegate?.didSelectCountry(selectedCountry)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.height
        let tableViewHeight = tableView.contentSize.height
        let scrollPosition = contentOffsetY + scrollViewHeight
        let threshold = tableViewHeight - 200
        
        if scrollPosition >= threshold && contentOffsetY > lastContentOffset {
            if let presenter = presenter, !presenter.isLoadingData {
                presenter.isLoadingData = true
                presenter.loadNextPage()
                tableView.reloadData()
            }
        }
        
        lastContentOffset = contentOffsetY
    }
}
