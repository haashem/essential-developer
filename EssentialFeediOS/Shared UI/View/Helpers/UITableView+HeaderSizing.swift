//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 15/03/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

extension UITableView {
    func sizeTableViewHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
