//
//  Api.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation
import Alamofire

protocol Requestable {
    var path: String { get }
    var method: ApiMethod { get }
    var parameter: Parameters { get }
}

enum ApiMethod {
    case get
    case post
    
    var value: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}

typealias Palameters = Parameters

class Api {
    private var configure: Requestable
    private var host: String {
        return "https://api.flickr.com"
    }
    
    private var parameters: Parameters {
        return configure.parameter
    }
    
    private var method: HTTPMethod {
        return configure.method.value
    }
    
    private var baseUrl: String {
        return host + configure.path
    }
    
    private init(configure: Requestable) {
        self.configure = configure
    }
    
    static func create(configure: Requestable) -> Api {
        return .init(configure: configure)
    }
    
    
    private func checkIsStatus(statusCode: Int) -> Bool {
        if 200 <= statusCode || statusCode < 300 {
            return true
        } else {
            return false
        }
    }
    
    func request(completion: @escaping ((Feed) -> Void)) {
        Alamofire.request(baseUrl, parameters: parameters).responseJSON { result in
            guard let response = result.response else { return }
            if self.checkIsStatus(statusCode: response.statusCode) {
                guard let responseData = result.data else { return }
                do {
                    let feed = try JSONDecoder().decode(Feed.self, from: responseData)
                    completion(feed)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
