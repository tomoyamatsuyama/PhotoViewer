//
//  MainViewModel.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel: NSObject, UICollectionViewDataSource {
    private var latitude: String = ""
    private var longitude: String = ""
    private(set) var photos: Variable<[Feed.Info]> = .init([])
    private let disposeBag = DisposeBag()
    
    func setPosition(lat: String, log: String) {
        self.latitude = lat
        self.longitude = log
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! HomeCollectionViewCell
        if !photos.value.isEmpty {
            cell.bind(cell, imageUrlString: self.photos.value[indexPath.row].url_n)
        }
        return cell
    }
        
    func bind(isRequestOfPositionList: Bool = false) {
        if isRequestOfPositionList {
            Api.Rest.getListByPosition(lat: latitude, log: longitude)
                .subscribe(
                    onNext: { [weak self] feed in
                        guard let `self` = self else { return }
                        self.photos.value = feed.photos.photo
                    }
                )
                .disposed(by: disposeBag)
        } else {
            Api.Rest.getList()
                .subscribe(
                    onNext: { [weak self] feed in
                        guard let `self` = self else { return }
                        self.photos.value = feed.photos.photo
                    }
                )
                .disposed(by: disposeBag)
        }
    }    
}
