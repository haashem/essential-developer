//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Hashem Abounajmi on 16/03/2022.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
