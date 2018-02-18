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

class SearchViewController: UIViewController, Instantiatable {
    @IBOutlet private weak var searchCollectionView: UICollectionView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet weak var headerTittle: UILabel!
    private let indicator = UIActivityIndicatorView()
    static var storyboardName: String = "SearchViewController"
    private var searchVM: SearchViewModel = SearchViewModel.init()
    private var imageUrlString: String = ""
    let cellMargin: CGFloat = 2.0
    
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
        Location.reverseGeoCoder(lat: Double(searchVM.latitude)!, log: Double(searchVM.longitude)!, completion: { [weak self] text in
            guard let `self` = self else { return }
            self.headerTittle.text = text
        })
        
        self.startIndicator(indicator: indicator)
        self.searchVM.reloadData(completion: { [weak self] in
            guard let `self` = self else { return }
            self.stopIndicator(indicator: self.indicator)
            self.searchCollectionView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCollectionView.dataSource = searchVM
        self.setImage()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageUrlString = self.searchVM.photos[indexPath.row]
        self.setImage()
    }
}
