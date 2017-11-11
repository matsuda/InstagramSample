//
//  Constants.swift
//  InstagramSample
//
//  Created by Kosuke Matsuda on 2017/11/12.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import Foundation

enum Constants {
    enum Instagram {
        private static let _AuthURL = "https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=%@"

        /// set CLIENT_ID with `InstagramClientId` as the key to Info.plist
        private static var _ClientId: String = {
            if let info = Bundle.main.infoDictionary,
                let value = info["InstagramClientId"] as? String
            {
                return value
            }
            fatalError("Missing InstagramClientId")
        }()

        /// set REDIRECT_URI with `InstagramRedirectUri` as the key to Info.plist
        static var RedirectUri: String = {
            if let info = Bundle.main.infoDictionary,
                let value = info["InstagramRedirectUri"] as? String
            {
                return value
            }
            fatalError("Missing InstagramRedirectUri")
        }()

        private static let _AuthResponseType = "token"

        static var AuthURL: String {
            return String(format: _AuthURL, _ClientId, RedirectUri, _AuthResponseType)
        }
    }
}
