//
//  SearchViewController.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Kingfisher
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, Instantiatable {
    @IBOutlet private weak var searchCollectionView: UICollectionView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet weak var headerTittle: UILabel!
    private let indicator = UIActivityIndicatorView()
    static var storyboardName: String = "SearchViewController"
    private var searchVM: SearchViewModel = SearchViewModel.init()
    private var imageUrlString: String = ""
    let cellMargin: CGFloat = 2.0
    private let disposeBag = DisposeBag()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setImage() {
        guard let url: URL = URL(string: self.imageUrlString) else { return }
        self.topImageView.kf.setImage(with: url)
    }
    
    func initialize(lat: String, log: String, imageUrlString: String) {
        self.searchVM.setPosition(lat: lat, log: log)
        self.imageUrlString = imageUrlString
        self.bind()
    }
    
    private func bind() {
        self.startIndicator(indicator: self.indicator)
        Location.reverseGeoCoder(lat: Double(searchVM.latitude)!, log: Double(searchVM.longitude)!, completion: { [weak self] text in
            guard let `self` = self else { return }
            self.headerTittle.text = text
        })
        
        searchVM.photos.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: {_ in
                    self.stopIndicator(indicator: self.indicator)
                    self.searchCollectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCollectionView.dataSource = searchVM
        self.setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchVM.reloadData()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageUrlString = self.searchVM.photos.value[indexPath.row].url_n
        self.setImage()
    }
}
