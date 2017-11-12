//
//  Response.swift
//  InstagramSample
//
//  Created by Kosuke Matsuda on 2017/11/12.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import Foundation

enum InstagramResponse {

    struct UserRecent: Codable {
        let meta: Meta
        let data: [Media]
    }

    struct Meta: Codable {
        enum Code: Int, Codable {
            case ok = 200
        }
        let code: Code
    }

    struct User: Codable {
        let id: String
        let username: String
    }

    struct ImageContainer: Codable {
        let thumbnail: Image
        let low_resolution: Image
        let standard_resolution: Image
    }

    struct Image: Codable {
        let width: Int
        let height: Int
        let url: String
    }

    struct Media: Codable {
        enum MediaType: String, Codable {
            case image
        }
        let id: String
        let type: MediaType
        let link: String
        let created_time: String
        let user: User
        let images: ImageContainer
    }

}

extension InstagramResponse {
    enum SampleJSON: String {
        case media_recent
    }
    static func load(sample: SampleJSON) throws -> Data {
        guard let path = Bundle.main.path(forResource: sample.rawValue, ofType: "json") else {
            throw NSError(domain: "InstagramResponse", code: 300, userInfo: [NSLocalizedDescriptionKey: "Not found \(sample.rawValue) JSON file"])
        }
        return try Data(contentsOf: URL(fileURLWithPath: path, isDirectory: true))
    }
}
