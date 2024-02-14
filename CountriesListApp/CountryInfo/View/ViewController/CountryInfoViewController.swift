//
//  CountryInfoViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryInfoViewController: UIViewController, UICollectionViewDelegate {
    
    struct Constants {
        struct Id {
            static let countryDescriptionTableViewCell = String(describing: CountryDescriptionTableViewCell.self)
            static let countryInfoTableViewCell = String(describing: CountryInfoTableViewCell.self)
            static let countryInfoTitleTableViewCell = String(describing: CountryInfoTitleTableViewCell.self)
            static let countryInfoCollectionViewCell = String(describing: CountryInfoCollectionViewCell.self)
        }
        
        struct RawsAndSectionsCountryInfoTableView {
            static let numbersOfSection = 3
            static let rawsInHeaderlSection = 1
            static let rawsInDescriptionSection = 1
            static let defaultRaws = 0
            static let headerSection = 0
            static let infoBlockSection = 1
            static let descriptionSection = 2
        }
    }
    
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    
    var presenter: CountryInfoPresenter?
    
    private lazy var tableViewDataSource: TableViewDataSourceWrapper = {
        guard let presenter = presenter else {
            fatalError("Presenter is not set")
        }
        return TableViewDataSourceWrapper(presenter: presenter)
    }()
    
    private lazy var tableViewDelegate: TableViewDelegateWrapper = {
        return TableViewDelegateWrapper()
    }()
    
    private lazy var collectionViewDataSource: CollectionViewDataSourceWrapper = {
        guard let presenter = presenter else {
            fatalError("Presenter is not set")
        }
        return CollectionViewDataSourceWrapper(presenter: presenter)
    }()
    
    private lazy var collectionViewDelegateFlowLayout: CollectionViewDelegateFlowLayoutWrapper = {
        return CollectionViewDelegateFlowLayoutWrapper()
    }()
    
    private lazy var scrollViewDelegate: ScrollViewDelegateWrapper = {
        return ScrollViewDelegateWrapper(pageControl: self.pageControl)
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        presenter?.view = self
        presenter?.getData()
        configureTableView()
        configureCollectionView()
    }
    
    // MARK: - UI Actions
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: Constants.Id.countryInfoTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.countryInfoTableViewCell)
        tableView.register(UINib(nibName: Constants.Id.countryDescriptionTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.countryDescriptionTableViewCell)
        tableView.register(UINib(nibName: Constants.Id.countryInfoTitleTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Id.countryInfoTitleTableViewCell)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: Constants.Id.countryInfoCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.Id.countryInfoCollectionViewCell)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegateFlowLayout
        collectionView.isPagingEnabled = true
    }
}

// MARK: - CountryInfoProtocol

extension CountryInfoViewController: CountryInfoProtocol {
    
    func present() {
        if let presenter {
            pageControl.numberOfPages = presenter.country.countryInfo.images.count
            pageControl.currentPage = 0
            tableView.reloadData()
            collectionView.reloadData()
            pageControl.isHidden = presenter.country.countryInfo.images.count == 1
        }
    }
}

class TableViewDataSourceWrapper: NSObject, UITableViewDataSource {
    weak var presenter: CountryInfoPresenter?
    
    init(presenter: CountryInfoPresenter) {
        self.presenter = presenter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.numbersOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.headerSection:
            return CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.rawsInHeaderlSection
        case CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.infoBlockSection:
            return presenter?.countryInfoArray?.count ?? 0
        case CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.descriptionSection:
            return CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.rawsInDescriptionSection
        default:
            return CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.defaultRaws
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.headerSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryInfoViewController.Constants.Id.countryInfoTitleTableViewCell, for: indexPath) as? CountryInfoTitleTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter {
                cell.configure(header: presenter.country.name)
            }
            
            return cell
            
        case CountryInfoViewController.Constants.RawsAndSectionsCountryInfoTableView.infoBlockSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryInfoViewController.Constants.Id.countryInfoTableViewCell, for: indexPath) as? CountryInfoTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter, let countryInfoArray = presenter.countryInfoArray {
                let cellInfo = countryInfoArray[indexPath.row]
                cell.configure(
                    constantText: cellInfo.labelFixed,
                    infoText: cellInfo.labelText,
                    image: cellInfo.image
                )
                
                return cell
            } else {
                return UITableViewCell()
            }
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryInfoViewController.Constants.Id.countryDescriptionTableViewCell, for: indexPath) as? CountryDescriptionTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter {
                cell.configure(description: presenter.country.description)
            }
            
            return cell
        }
    }
}

class TableViewDelegateWrapper: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
}

class CollectionViewDataSourceWrapper: NSObject, UICollectionViewDataSource {
    weak var presenter: CountryInfoPresenter?
    
    init(presenter: CountryInfoPresenter) {
        self.presenter = presenter
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageCount = presenter?.country.countryInfo.images.count, imageCount > 0 {
            return imageCount
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryInfoViewController.Constants.Id.countryInfoCollectionViewCell, for: indexPath) as? CountryInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let presenter {
            cell.configure(with: presenter.country, index: indexPath.row)
        }
        
        return cell
    }
}

class CollectionViewDelegateFlowLayoutWrapper: NSObject, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

class ScrollViewDelegateWrapper: NSObject, UIScrollViewDelegate {
    weak var pageControl: UIPageControl?
    
    init(pageControl: UIPageControl) {
        self.pageControl = pageControl
        super.init()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let pageControl = pageControl else { return }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let pageControl = pageControl else { return }
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

