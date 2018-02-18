//
//  MainViewModel.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel: NSObject, UICollectionViewDataSource {
    private(set) var photos: [String] = []
    private(set) var latitudes: [String] = []
    private(set) var longitudes: [String] = []
    private var latitude: String = ""
    private var longitude: String = ""
    
    func setPosition(lat: String, log: String) {
        self.latitude = lat
        self.longitude = log
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! HomeCollectionViewCell
        cell.bind(cell, imageUrlString: photos[indexPath.row])
        return cell
    }
    
    private func initialize() {
        self.photos = .init()
        self.latitudes = .init()
        self.longitudes = .init()
    }
    
    private func setData(feed: Feed) {
        for photo in feed.photos.photo {
            self.photos.append(photo.url_n)
            self.latitudes.append(photo.latitude)
            self.longitudes.append(photo.longitude)
        }
    }
    
    func reloadData(isRequestOfPositionList: Bool, completion: (() -> Void)? = nil) {
        self.initialize()
        if isRequestOfPositionList {
            Api.Rest.getListByPosition(lat: latitude, log: longitude, completion: { [weak self] feed in
                guard let `self` = self else { return }
                self.setData(feed: feed)
                completion?()
            })
        } else {
            Api.Rest.getList(completion: { [weak self] feed in
                guard let `self` = self else { return }
                self.setData(feed: feed)
                completion?()
            })
        }
    }
}
