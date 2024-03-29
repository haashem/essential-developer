//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 17/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
