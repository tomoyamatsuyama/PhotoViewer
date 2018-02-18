//
//  HomeCollectionViewCell.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func bind(_ cell: HomeCollectionViewCell, imageUrlString: String) {
        guard let url: URL = URL(string: imageUrlString) else { return }
        self.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.5))] , progressBlock: nil, completionHandler: nil)
    }
}
