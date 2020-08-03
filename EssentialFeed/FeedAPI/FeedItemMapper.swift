//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 3/14/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation


internal struct RemoteFeedItem: Decodable {
    
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}

final class FeedItemMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
