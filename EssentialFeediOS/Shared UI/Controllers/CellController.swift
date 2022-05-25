//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Hashem Abounajmi on 25/05/2022.
//  Copyright © 2022 Hashem Aboonajmi. All rights reserved.
//

import UIKit

public struct CellController {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let prefetching: UITableViewDataSourcePrefetching?
    
    public init(_ dataSource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.dataSource = dataSource
        self.delegate = dataSource
        self.prefetching = dataSource
    }
    
    public init(_ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        self.delegate = nil
        self.prefetching = nil
    }
}
