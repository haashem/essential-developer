//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 17/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public struct FeedImageViewModel<T> {
    public let description: String?
    public let location: String?
    public let image: T?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
}
