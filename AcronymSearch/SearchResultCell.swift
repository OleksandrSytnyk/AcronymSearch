//
//  SearchResultCell.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/25/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(for acronymMeaning: AcronymMeaning) {
        
        titleLabel.text = acronymMeaning.name
        frequencyLabel.text = String(acronymMeaning.freq)
        dateLabel.text = String(acronymMeaning.since)
    }
}
