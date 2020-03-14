//
//  FeedAPI.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 3/12/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { result in
            switch result {
                case .success(let data, let response):
                    if response.statusCode == 200,  let items = try? JSONDecoder().decode(Root.self, from: data).items {
                        completion(.success(items.map {$0.item }))
                    } else {
                        completion(.failure(.invalidData))
                }
                case .failure(let error):
                    completion(.failure(.connectivity))
                
            }
        }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case image
    }
    
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}
