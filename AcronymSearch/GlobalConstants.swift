//
//  GlobalConstants.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/24/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import Foundation

struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
}

typealias SearchComplete = ([AcronymMeaning]) -> Void
