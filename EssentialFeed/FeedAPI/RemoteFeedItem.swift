//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Hashem Aboonajmi on 8/3/20.
//  Copyright © 2020 Hashem Aboonajmi. All rights reserved.
//

import Foundation

 struct RemoteFeedItem: Decodable {
    
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
