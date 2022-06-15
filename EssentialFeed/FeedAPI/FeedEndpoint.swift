//
//  FeedEndPoint.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 15/06/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            return components.url!
        }
    }
}
