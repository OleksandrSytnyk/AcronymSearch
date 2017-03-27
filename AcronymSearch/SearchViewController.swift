//
//  ViewController.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/25/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    enum State {
        case notSearchedYet
        case noResults
        case results([AcronymMeaning])
    }
    
    static let showDetailsScreen = "showDetailsScreen"
    var details: [AcronymMeaning] = []
    var searchResults: [AcronymMeaning] = []
    private (set) var state: State = .notSearchedYet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        createSearchBar()
        
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
     }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your search here!"
        searchBar.becomeFirstResponder()
        searchBar.barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255,
                                         alpha: 1)
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error searching for an acronym. Please try again.",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func performSearch() {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = MBProgressHUDMode.indeterminate
        progressHUD.label.text = "Loading"
        var acronym = Acronym()
        if let name = searchBar.text {
            acronym.name = name
        }
        
        DataManager.shared.performSearch(for: acronym, successHandler: { [unowned self] results in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.state = .notSearchedYet
            
            if results.isEmpty {
                self.state = .noResults
            } else {
                self.state = .results(results)
            }
            self.tableView.reloadData()
            self.searchBar.resignFirstResponder()
        },
         errorHandler: { [unowned self] errorString in
            self.showNetworkError()
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Error when trying to download acronym meanings: " + (errorString ?? ""))
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch self.state {
        case .notSearchedYet:
            return 0
        case .noResults:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.state {
        case .notSearchedYet:
            fatalError("Should never get here")
            
        case .noResults:
            return tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                for: indexPath)
            
        case .results(let list):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell,
                for: indexPath)
            let searchResult = list[indexPath.row]
            if let cell = cell as? SearchResultCell {
                cell.configure(for: searchResult)
            }
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        
        if case let .results(list) = self.state, let variants = list[indexPath.row].variants {
            details = variants
        }
        performSegue(withIdentifier: SearchViewController.showDetailsScreen, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch self.state {
        case .notSearchedYet, .noResults:
            return nil
        case .results:
            return indexPath
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchViewController.showDetailsScreen {
          self.navigationController?.isNavigationBarHidden = false
            
            if let detailsViewController = segue.destination as? DetailsTableViewController {
                detailsViewController.details = details
            }
        }
    }
}

