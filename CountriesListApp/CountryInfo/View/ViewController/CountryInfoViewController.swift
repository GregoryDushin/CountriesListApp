//
//  CountryInfoViewController.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 12.01.2024.
//

import UIKit

final class CountryInfoViewController: UIViewController {
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    
    var presenter: CountryInfoPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        presenter?.view = self
        presenter?.getData()
        configureTableView()
        configureCollectionView()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: Id.countryInfoTableViewCell, bundle: nil), forCellReuseIdentifier: Id.countryInfoTableViewCell)
        tableView.register(UINib(nibName: Id.countryDescriptionTableViewCell, bundle: nil), forCellReuseIdentifier: Id.countryDescriptionTableViewCell)
        tableView.register(UINib(nibName: Id.countryInfoTitleTableViewCell, bundle: nil), forCellReuseIdentifier: Id.countryInfoTitleTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: Id.countryInfoCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Id.countryInfoCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }
}

// MARK: - CountryInfoProtocol

extension CountryInfoViewController: CountryInfoProtocol {
    
    func present() {
        if let presenter = presenter {
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
        rawsAndSectionsCountryInfoTableView.numbersOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return rawsAndSectionsCountryInfoTableView.rawsInCarouselSection
        case 1:
            if let presenter = presenter, let countryArray = presenter.countryInfoArray {
                return countryArray.count
            } else {
                return 0
            }
        case 2:
            return rawsAndSectionsCountryInfoTableView.rawsInInfoBlockSection
        default:
            return rawsAndSectionsCountryInfoTableView.defaultRaws
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.countryInfoTitleTableViewCell, for: indexPath) as? CountryInfoTitleTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter {
                cell.configure(header: presenter.country.name)
            }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.countryInfoTableViewCell, for: indexPath) as? CountryInfoTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter, let countryInfoArray = presenter.countryInfoArray {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.countryDescriptionTableViewCell, for: indexPath) as? CountryDescriptionTableViewCell else {
                return UITableViewCell()
            }
            
            if let presenter = presenter {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Id.countryInfoCollectionViewCell, for: indexPath) as? CountryInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let presenter{
            cell.configure(with: presenter.country, imageLoader: ImageLoader(), index: indexPath.row)
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
