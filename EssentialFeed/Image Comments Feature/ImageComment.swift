//
//  ImageComment.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 27/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

public struct ImageComment: Equatable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String

    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
