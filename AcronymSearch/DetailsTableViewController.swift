//
//  DetailsTableViewController.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/24/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    var details:[AcronymMeaning] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        tableView.estimatedRowHeight = 60
    }
 
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath)
        let detail = details[indexPath.row]
        if let cell = cell as? SearchResultCell {
             cell.configure(for: detail)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }  
}
