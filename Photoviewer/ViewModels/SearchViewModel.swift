//
//  SearchViewModel.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchViewModel: NSObject, UICollectionViewDataSource {
    private(set) var latitude: String = ""
    private(set) var longitude: String = ""
    private(set) var photos: Variable<[Feed.Info]> = .init([])
    private let disposeBag = DisposeBag()
    
    func setPosition(lat: String, log: String) {
        self.latitude = lat
        self.longitude = log
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serachViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.bind(cell, imageUrlString: photos.value[indexPath.row].url_n)
        return cell
    }
    
    func reloadData(completion: (() -> Void)? = nil) {
        Api.Rest.getListByPosition(lat: latitude, log: longitude)
            .subscribe(
                onNext: { [weak self] feed in
                    guard let `self` = self else { return }
                    self.photos.value = feed.photos.photo
                }
            )
            .disposed(by: disposeBag)
    }
}
