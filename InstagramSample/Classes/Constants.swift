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
            if let value = Bundle.main.infoDictionary?["InstagramClientId"] as? String {
                return value
            }
            fatalError("Missing InstagramClientId")
        }()

        /// set REDIRECT_URI with `InstagramRedirectUri` as the key to Info.plist
        static var RedirectUri: String = {
            if let value = Bundle.main.infoDictionary?["InstagramRedirectUri"] as? String {
                return value
            }
            fatalError("Missing InstagramRedirectUri")
        }()

        private static let _AuthResponseType = "token"

        static var AuthURL: String {
            return String(format: _AuthURL, _ClientId, RedirectUri, _AuthResponseType)
        }

        static let BaseURL = "https://api.instagram.com/v1"

        enum Endpoint {
            case selfRecent

            var path: String {
                switch self {
                case .selfRecent:
                    return "/users/self/media/recent/"
                }
            }
        }

        static func buildURL(
            endpoint: Constants.Instagram.Endpoint,
            parameters: [String: Any]? = nil
            ) -> URL
        {
            let baseURL = Constants.Instagram.BaseURL.appending(endpoint.path)
            var comps = URLComponents(string: baseURL)!
            if let parameters = parameters, !parameters.isEmpty {
                var items: [URLQueryItem] = []
                parameters.forEach { (key, value) in
                    items.append(URLQueryItem(name: key, value: "\(value)"))
                }
                comps.queryItems = items
            }
            return comps.url!
        }
    }
}

typealias Instagram = Constants.Instagram
