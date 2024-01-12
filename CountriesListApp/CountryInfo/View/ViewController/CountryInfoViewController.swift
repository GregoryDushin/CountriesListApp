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

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.view = self
        presenter?.getData()
        

        title = country?.name ?? "Country Info"

        tableView.register(UINib(nibName: "CountryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryInfoCell")
        tableView.register(UINib(nibName: "CountryDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryDescriptionCell")
        tableView.dataSource = self
        tableView.delegate = self

        collectionView.register(UINib(nibName: "CountryInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CountryInfoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true

        pageControl.numberOfPages = country?.image?.count ?? 1
        pageControl.currentPage = 0
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
}

extension CountryInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3 // Количество ячеек для первой секции
        } else {
            return 1 // Количество ячеек для второй секции
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Ячейки для первой секции
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryInfoCell", for: indexPath) as? CountryInfoTableViewCell else {
                return UITableViewCell()
            }

            cell.constantLabel.text = "Название"
            cell.infoLabel.text = "Допинфо"

            return cell
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDescriptionCell", for: indexPath) as? CountryDescriptionTableViewCell else {
                return UITableViewCell()
            }

            cell.descriptionLabel.text = country?.description

            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let headerLabel = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 20))
        headerLabel.textColor = UIColor.black
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)

        if section == 0 {
            headerLabel.text = "Хедер_1"
        } else {
            headerLabel.text = "Хедер_2"
        }

        headerView.addSubview(headerLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension CountryInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Действия при выборе ячейки
    }
}

extension CountryInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageCount = country?.countryInfo.images.count, imageCount > 0 {
            return imageCount
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryInfoCollectionViewCell", for: indexPath) as? CountryInfoCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: country!, imageLoader: ImageLoader(), indexPath: indexPath.row)

        return cell
    }
}

extension CountryInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

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

extension CountryInfoViewController: CountryInfoProtocol {

    func success(data: Country) {
        self.country = data
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func failure(error: Error) {
        showAlert(error.localizedDescription)
    }
}
