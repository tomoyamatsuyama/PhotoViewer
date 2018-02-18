//
//  ApiInfomation.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/16.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import Foundation


class ApiInfomation {
    enum Key {
        case accessToken
        case scope
        case apiSecret
        case apiKey
        
        var value: String {
            switch self {
            case .accessToken:
                return "access_token"
            case .scope:
                return "scope"
            case .apiSecret:
                return "client_secret"
            case .apiKey:
                return "api_key"
            }
        }
    }
    
    private static var configPlist: NSMutableDictionary {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType:"plist" ) else {
            fatalError("")
        }
        guard let cinfigfile = NSMutableDictionary(contentsOfFile:filePath) else {
            fatalError("")
        }
        return cinfigfile
    }
    
    static func set(key: Key, value: Any) {
        UserDefaults.standard.set(value, forKey: "access_token")
    }
    
    static func get(key: Key) -> Any {
        switch key {
        case .accessToken:
            guard let value = UserDefaults.standard.string(forKey: "access_token") else {
                fatalError("")
            }
            return value
        default:
            guard let value = configPlist.value(forKey: key.value) else {
                fatalError("")
            }
            return value
        }
        
    }
}
