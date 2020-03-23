//
//  FeedAPI.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success(data, response):
                    completion(FeedItemMapper.map(data, response))
                case .failure(_):
                    completion(.failure(.connectivity))
                
            }
        }
    }
    
}
