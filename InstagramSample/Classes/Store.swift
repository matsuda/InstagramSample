//
//  Store.swift
//  InstagramSample
//
//  Created by Kosuke Matsuda on 2017/11/12.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import Foundation
import KeychainAccess

class Store {
    enum Key: String {
        case accessToken
    }

    static let shared = Store()

    private init() {}

    var accessToken: String? {
        get {
            return Keychain()[Key.accessToken.rawValue]
        }
        set {
            Keychain()[Key.accessToken.rawValue] = newValue
        }
    }
}
