//
//  CountriesListViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import Foundation
import UIKit

final class CountriesListViewController: UIViewController {
    
    // MARK: - Constants
    
    struct Constants {
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
    
    // MARK: - Properties
    
    private var lastContentOffset: CGFloat = 0
    var presenter: CountriesListPresenter?
    weak var coordinatorDelegate: CountriesListCoordinator?
    private var isShowingActivityIndicator: Bool = false
    
    // MARK: - UI Elements
    
    private lazy var tableViewDataSource: TableViewDataSource = {
        let dataSource = TableViewDataSource(presenter: presenter!, isShowingActivityIndicator: isShowingActivityIndicator)
        return dataSource
    }()
    
    private lazy var tableViewDelegate: TableViewDelegate = {
        let delegate = TableViewDelegate(presenter: presenter!, coordinatorDelegate: coordinatorDelegate!)
        return delegate
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib(nibName: Constants.Id.customTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.customTableViewCell)
        tableView.register(UINib(nibName: Constants.Id.activityIndicatorTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.activityIndicatorTableViewCell)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTableView()
        presenter?.view = self
        presenter?.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateClearButtonStyle()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.UI.countriesScreenNavigationItemTitle
        createClearButton()
    }
    
    private func setupTableView() {
        setupPullToRefresh()
    }
    
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
    
    // MARK: - Actions
    
    @objc private func clearButtonTapped() {
        presenter?.clearMemory()
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

// MARK: - TableViewDataSource

class TableViewDataSource: NSObject, UITableViewDataSource {
    var presenter: CountriesListPresenter?
    var isShowingActivityIndicator: Bool = false
    
    init(presenter: CountriesListPresenter, isShowingActivityIndicator: Bool) {
        self.presenter = presenter
        self.isShowingActivityIndicator = isShowingActivityIndicator
    }
    
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListViewController.Constants.Id.customTableViewCell, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter, let countries = presenter.countries {
                let country = countries[indexPath.row]
                cell.configure(with: country)
                return cell
            } else {
                return UITableViewCell()
            }
            
        } else {
            let activityIndicatorCell = tableView.dequeueReusableCell(withIdentifier: CountriesListViewController.Constants.Id.activityIndicatorTableViewCell, for: indexPath) as? ActivityIndicatorTableViewCell
            return activityIndicatorCell ?? UITableViewCell()
        }
    }
}

// MARK: - TableViewDelegate

class TableViewDelegate: NSObject, UITableViewDelegate {
    weak var coordinatorDelegate: CountriesListCoordinator?
    var presenter: CountriesListPresenter?
    
    init(presenter: CountriesListPresenter, coordinatorDelegate: CountriesListCoordinator) {
        self.presenter = presenter
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let presenter = presenter, let countries = presenter.countries {
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
