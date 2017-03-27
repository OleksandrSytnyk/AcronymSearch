//
//  lf.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/25/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import Foundation

struct AcronymMeaning {
    var name = ""
    var freq = -1
    var since = -1
    var variants: [AcronymMeaning]? = []
}
