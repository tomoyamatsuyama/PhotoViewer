//
//  SearchViewModel.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel: NSObject, UICollectionViewDataSource {
    private(set) var latitude: String = ""
    private(set) var longitude: String = ""
    private(set) var photos: [String] = []
    
    func setPosition(lat: String, log: String) {
        self.latitude = lat
        self.longitude = log
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serachViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.bind(cell, imageUrlString: photos[indexPath.row])
        return cell
    }
    
    func reloadData(completion: (() -> Void)? = nil) {
        Api.Rest.getListByPosition(lat: latitude, log: longitude, completion: { feed in
            for photo in feed.photos.photo {
                self.photos.append(photo.url_n)
            }
            completion?()
        })
    }
}
