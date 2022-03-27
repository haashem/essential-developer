//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 27/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public final class RemoteImageCommentsLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[ImageComment], Swift.Error>
    
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success((data, response)):
                    completion(RemoteImageCommentsLoader.map(data, from: response))
                case .failure(_):
                    completion(.failure(Error.connectivity))
                
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}


