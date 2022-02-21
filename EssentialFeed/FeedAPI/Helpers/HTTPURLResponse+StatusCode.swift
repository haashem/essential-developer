//
//  Helpers.swift
//  EssentialFeed
//
//  Created by Hashem Abounajmi on 21/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isHTTPURLResponseOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
