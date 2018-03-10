//
//  HomeViewController.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

enum SearchBar: CGFloat {
    case hidden = -56
    case show = 0
    
    var constant: CGFloat {
        switch self {
        case .hidden:
            return -56
        case .show:
            return 0
        }
    }
}

class HomeViewController: UIViewController {
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var mainTittle: UILabel!
    @IBOutlet private weak var findButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchBarConstraint: NSLayoutConstraint!
    let cellMargin: CGFloat = 2.0
    static let storyboardName: String = "HomeViewController"
    private let homeVM = HomeViewModel()
    private let indicator = UIActivityIndicatorView()
    var locationManager: CLLocationManager!
    private var isSearchBarHidden = true
    private let disposeBag = DisposeBag()
    
    @IBAction func findButtonTapped(_ sender: Any) {
        self.operateSearchBar()
    }
    
    @IBAction func nearButtonTapped(_ sender: Any) {
        self.homeVM.bind(isRequestOfPositionList: true)
    }
    
    private func operateSearchBar() {
        if isSearchBarHidden {
            self.animatesSearchBar(constant: SearchBar.show.constant)
            self.findButton.setTitle("End", for: .normal)
        } else {
            self.animatesSearchBar(constant: SearchBar.hidden.constant)
            self.findButton.setTitle("Find", for: .normal)
        }
        isSearchBarHidden = !isSearchBarHidden
    }
    
    private func animatesSearchBar(constant: CGFloat) {
        searchBarConstraint.constant = constant
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func bindViewModel() {
        self.startIndicator(indicator: self.indicator)
        homeVM.photos.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: {_ in
                    self.stopIndicator(indicator: self.indicator)
                    self.mainCollectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    func setPosition(lat: String, log: String) {
        self.homeVM.setPosition(lat: lat, log: log)
    }
    
    private func goToSerachBar(lat: String, log: String, imageUrlString: String) {
        let searchVC = SearchViewController.instantiate()
        searchVC.initialize(lat: lat, log: log, imageUrlString: imageUrlString)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func reload(lat: String, log: String) {
        self.homeVM.setPosition(lat: lat, log: log)
        self.homeVM.bind(isRequestOfPositionList: true)
    }
    
    private func configure() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.setupLocationManager()
        self.mainCollectionView.dataSource = homeVM
        self.mainCollectionView.delegate = self
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = "Enter your search here"
    }
    
    static func instantiate() -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else { fatalError("error") }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.bindViewModel()
        self.homeVM.bind()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let latitude = self.homeVM.photos.value[indexPath.row].latitude
        let longtitude = self.homeVM.photos.value[indexPath.row].longitude
        self.goToSerachBar(lat: latitude, log: longtitude, imageUrlString: self.homeVM.photos.value[indexPath.row].url_n)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.operateSearchBar()
        guard let text = searchBar.text else { return }
        Location.geoCoder(text: text, completion: { [weak self] position in
            guard let `self` = self else { return }
            self.reload(lat: position.latitude, log: position.longtitude)
        })
    }
}
