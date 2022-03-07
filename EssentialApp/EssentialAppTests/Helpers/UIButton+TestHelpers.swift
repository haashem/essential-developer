//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Hashem Abounajmi on 24/01/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
