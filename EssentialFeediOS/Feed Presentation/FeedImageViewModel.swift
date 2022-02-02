//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 29/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }

}
