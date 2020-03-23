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
        let items: [Item]
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
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
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}
