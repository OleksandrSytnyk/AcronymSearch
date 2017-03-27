//
//  DataManager.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/26/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import Foundation

/**
 * Data Manager is designed to encapsulate work with all data in the project and
 * to coordinate work with Network Manager and other managers like persistence (Realm or Core Data),
 * Caching, etc
 */
class DataManager {
    
    static let shared: DataManager = {
        let instance = DataManager()
        return instance
    }()

    func performSearch(for acronym: Acronym?, successHandler: @escaping SearchComplete, errorHandler: @escaping (String?) -> Void) {
                NetworkManager.shared.performSearch(for: acronym, successHandler: successHandler, errorHandler: errorHandler)
    }    
}
