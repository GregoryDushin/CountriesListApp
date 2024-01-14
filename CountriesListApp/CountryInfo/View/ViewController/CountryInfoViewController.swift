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
    var country: Country?
    var countryModel: [CountryInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.view = self
        presenter?.getData()
        
        tableView.register(UINib(nibName: Id.countryInfoTableViewCell, bundle: nil), forCellReuseIdentifier: Id.countryInfoTableViewCell)
        tableView.register(UINib(nibName: Id.countryDescriptionTableViewCell, bundle: nil), forCellReuseIdentifier: Id.countryDescriptionTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.register(UINib(nibName: Id.countryInfoCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Id.countryInfoCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }
    
    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

// MARK: - CountryInfoProtocol

extension CountryInfoViewController: CountryInfoProtocol {
    
    func success(data: [CountryInfoModel], data2: Country) {
        self.countryModel = data
        self.country = data2
        self.pageControl.numberOfPages = data2.countryInfo.images.count
        self.pageControl.currentPage = 0
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func failure(error: Error) {
        showAlert(error.localizedDescription)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CountryInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? countryModel.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.countryInfoTableViewCell, for: indexPath) as? CountryInfoTableViewCell else {
                return UITableViewCell()
            }
            
            let cellInfo = countryModel[indexPath.row]
            cell.configure(
                constantText: cellInfo.labelFixed,
                infoText: cellInfo.labelText,
                image: cellInfo.image)
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Id.countryDescriptionTableViewCell, for: indexPath) as? CountryDescriptionTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(description: country?.description ?? "description")
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 20))
        headerLabel.textColor = UIColor.black
        headerLabel.font = UIFont.boldSystemFont(ofSize: (section == 0) ? 20 : 17)
        headerLabel.text = (section == 0) ? country?.name : "О стране"
        
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 50 : 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor.clear
            headerView.backgroundView?.backgroundColor = UIColor.clear
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CountryInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageCount = country?.countryInfo.images.count, imageCount > 0 {
            return imageCount
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Id.countryInfoCollectionViewCell, for: indexPath) as? CountryInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: country!, imageLoader: ImageLoader(), indexPath: indexPath.row)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CountryInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate

extension CountryInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
}
