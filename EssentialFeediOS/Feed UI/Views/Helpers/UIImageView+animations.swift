//
//  UIImageView+animations.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 09/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        guard newImage != nil else { return }
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
