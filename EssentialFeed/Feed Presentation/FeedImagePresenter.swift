//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 17/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

final public class FeedImagePresenter {

    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
