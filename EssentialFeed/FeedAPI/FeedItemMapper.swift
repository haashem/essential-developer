//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 3/14/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

final class FeedItemMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isHTTPURLResponseOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
