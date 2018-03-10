//
//  Feeds.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension Api {
    struct Rest {
        private enum Requests: Requestable {
            case list
            case position(latitude: String, longitude: String)
            
            var path: String {
                switch self {
                case .list:
                    return "/services/rest"
                case .position:
                    return "/services/rest"
                }
            }
            
            var method: ApiMethod {
                return .get
            }
            
            var parameter: Parameters {
                switch self {
                case .list:
                    return [
                        "api_key":ApiInfomation.get(key: .apiKey),
                        "extras":"url_n,geo",
                        "format":"json",
                        "method":"flickr.photos.search",
                        "has_geo": 1,
                        "content_type": 1,
                        "nojsoncallback": 1,
                        "page": 1
                    ]
                case .position(let latitude, let longitude):
                    return [
                        "api_key":ApiInfomation.get(key: .apiKey),
                        "extras":"url_n,geo",
                        "format":"json",
                        "method":"flickr.photos.search",
                        "has_geo": 1,
                        "content_type": 1,
                        "nojsoncallback": 1,
                        "page": 1,
                        "lat": latitude,
                        "lon": longitude
                    ]
                }
            }
        }
        
        static func getList() -> Observable<Feed> {
            return Api.create(configure: Requests.list).request()
        }
        
        static func getListByPosition(lat: String,log: String) -> Observable<Feed> {
            return Api.create(configure: Requests.position(latitude: lat, longitude: log)).request()
        }
    }
}
