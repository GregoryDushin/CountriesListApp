//
//  CountryInfoViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryInfoViewController: UIViewController {
    
    private struct Constants {
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
    
// MARK: - lifecycle
    
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
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: Constants.Id.countryInfoCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.Id.countryInfoCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
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

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountryInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.RawsAndSectionsCountryInfoTableView.numbersOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.RawsAndSectionsCountryInfoTableView.headerSection:
            return Constants.RawsAndSectionsCountryInfoTableView.rawsInHeaderlSection
        case Constants.RawsAndSectionsCountryInfoTableView.infoBlockSection:
            if let presenter, let countryArray = presenter.countryInfoArray {
                return countryArray.count
            } else {
                return 0
            }
        case Constants.RawsAndSectionsCountryInfoTableView.descriptionSection:
            return Constants.RawsAndSectionsCountryInfoTableView.rawsInDescriptionSection
        default:
            return Constants.RawsAndSectionsCountryInfoTableView.defaultRaws
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Constants.RawsAndSectionsCountryInfoTableView.headerSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.countryInfoTitleTableViewCell, for: indexPath) as? CountryInfoTitleTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter {
                cell.configure(header: presenter.country.name)
            }
            
            return cell
            
        case Constants.RawsAndSectionsCountryInfoTableView.infoBlockSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.countryInfoTableViewCell, for: indexPath) as? CountryInfoTableViewCell else {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Id.countryDescriptionTableViewCell, for: indexPath) as? CountryDescriptionTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter {
                cell.configure(description: presenter.country.description)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
}


// MARK: - UICollectionViewDataSource

extension CountryInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageCount = presenter?.country.countryInfo.images.count, imageCount > 0 {
            return imageCount
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Id.countryInfoCollectionViewCell, for: indexPath) as? CountryInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let presenter {
            cell.configure(with: presenter.country, index: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CountryInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UIScrollViewDelegate

extension CountryInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
