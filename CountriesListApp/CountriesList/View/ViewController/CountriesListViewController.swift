//
//  CountriesListViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit
import CoreData

final class CountriesListViewController: UIViewController {
    
    private struct Constants {
        struct Id {
            static let customTableViewCell = String(describing: CustomTableViewCell.self)
            static let activityIndicatorTableViewCell = String(describing: ActivityIndicatorTableViewCell.self)
        }
        
        struct UI {
            static let countriesScreenNavigationItemTitle = "Страны"
            static let clearButtonTitle = "Очистить"
            static let setupPullToRefreshTime = 2
            static let numbersOfSection = 2
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    var presenter: CountriesListPresenter?
    weak var coordinatorDelegate: CountriesListCoordinator?
    private var coreDataManager: CoreDataManagerProtocol?
    private var isShowingActivityIndicator: Bool = false
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib(nibName: Constants.Id.customTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.customTableViewCell)
        tableView.register(UINib(nibName: Constants.Id.activityIndicatorTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.activityIndicatorTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
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
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func failure() {
        if let presenter, let presenterError = presenter.error {
            Utils.showAlert(on: self, message: presenterError)
        }
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func showLoadingIndicator(_ show: Bool) {
        isShowingActivityIndicator = show
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presenter?.countries?.count ?? 0
        } else {
            return isShowingActivityIndicator ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.customTableViewCell, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter, let countries = presenter.countries {
                let country = countries[indexPath.row]
                cell.configure(with: country)
                
                if let coreDataManager {
                    if let cachedHeight = coreDataManager.fetchCachedHeight(for: country.name) {
                        cell.setCachedHeight(cachedHeight)
                    } else {
                        let height = cell.calculateHeight()
                        coreDataManager.cacheHeight(height, for: country.name)
                        cell.setCachedHeight(height)
                    }
                }
                
                return cell
            } else {
                return UITableViewCell()
            }
            
        } else {
            let activityIndicatorCell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.activityIndicatorTableViewCell, for: indexPath) as? ActivityIndicatorTableViewCell
            return activityIndicatorCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let presenter, let countries = presenter.countries {
            let selectedCountry = countries[indexPath.row]
            coordinatorDelegate?.didSelectCountry(selectedCountry)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let presenter = presenter, !presenter.isLoadingData , let presenterCountries = presenter.countries {
            if indexPath.row == presenterCountries.count - 1 {
                presenter.loadNextPage()
            }
        }
    }
}
