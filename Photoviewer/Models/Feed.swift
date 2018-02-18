//
//  Feed.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation


struct Feed: Codable {
    var photos: Photo
    struct Photo: Codable {
        var photo: [Info]
    }
    struct Info: Codable {
        var url_n: String
        var latitude: String
        var longitude: String
    }
}
