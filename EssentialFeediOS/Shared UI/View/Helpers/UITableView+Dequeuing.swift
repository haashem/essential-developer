//
//  UITableView+Dequeuing.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 09/02/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
