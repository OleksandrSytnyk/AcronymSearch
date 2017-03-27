//
//  AppearanceManager.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/26/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import Foundation

class AppearanceManager {
    
    class func customizeAppearance() {
        let barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255,
                                   alpha: 1)
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.orange
    }
    
}
