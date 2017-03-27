//
//  NetworkManager.swift
//  AcronymSearch
//
//  Created by Oleksandr Sytnyk on 3/25/17.
//  Copyright © 2017 Oleksandr Sytnyk. All rights reserved.
//

import Foundation

/**
 *  Network Manager is designed to encapsulate all network operations
 *
 */
class NetworkManager {
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for acronym: Acronym?, successHandler: @escaping SearchComplete, errorHandler: @escaping (String?) -> Void) {
        
        guard let text = acronym?.name, !text.isEmpty else {
            errorHandler("Please provide Search Text")
            return
        }
        
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        
        guard let url = makeURL(searchText: text) else { return }
        
        dataTask = session.dataTask(with: url, completionHandler: {
          [weak self] data, response, error in
            var results:[AcronymMeaning] = []
            var success = false
            var httpStatusCodeString = ""
            
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                if statusCode == 200 {
                    if let jsonData = data, let jsonArray = self?.parse(json: jsonData), let possibleResults = self?.parse(jsonArray: jsonArray) {
                        results = possibleResults
                    }
                    success = true
                } else {
                    httpStatusCodeString = "dataTaskWithRequest HTTP status code: " + String(statusCode)
                }
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let error = error {
                    errorHandler("network error: \(error)" + "\n" + httpStatusCodeString)
                } else if success {
                    successHandler(results)
                } else {
                    errorHandler(httpStatusCodeString)
                }
            }
        })
        dataTask?.resume()
    }
    
    private func makeURL(searchText: String) -> URL? {
        guard let escapedSearchText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return nil}
        let urlString = String(format: "http://www.nactem.ac.uk/software/acromine/dictionary.py",
                               escapedSearchText)
        let parameters:[String: Any] = ["sf": searchText, "lf": ""]
        let parameterString = parameters.stringFromHttpParameters()
        let url = URL(string: "\(urlString)?\(parameterString)")
        
        print("URL: \(url)")
        return url
    }
    
    private func parse(json data: Data) -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    private func parse(jsonArray: [Any]) -> [AcronymMeaning] {
        guard jsonArray.count != 0, let  jsonDictionary = jsonArray[0] as? [String: Any], let lfsJsonArray = jsonDictionary["lfs"] as? [Any] else {
                print("Expected 'results' array")
                return []
        }
        var searchResults: [AcronymMeaning] = []
        
        for i in 0...(lfsJsonArray.count - 1) {
            let commonItem = lfsJsonArray[i] as? [String: Any]
            var acronymMeaning = AcronymMeaning()
            var variants: [AcronymMeaning]? = []

            if let name = commonItem?["lf"] as? String {
                acronymMeaning.name = name
            }
            
            if let freq = commonItem?["freq"] as? Int {
               acronymMeaning.freq = freq
            }
            
            if let since = commonItem?["since"] as? Int {
                acronymMeaning.since = since
            }
            
            if let jsonCaseItem = commonItem?["vars"] as? [Any] {
                for j in 0...(jsonCaseItem.count - 1) {
                    let caseItem = jsonCaseItem[j] as? [String: Any]
                    
                    var caseAcronymMeaning = AcronymMeaning()
                    
                    if let name = caseItem?["lf"] as? String {
                        caseAcronymMeaning.name = name
                    }
                    if let freq = caseItem?["freq"] as? Int {
                        caseAcronymMeaning.freq = freq
                    }
                    
                    if let since = caseItem?["since"] as? Int {
                        caseAcronymMeaning.since = since
                    }
                    variants?.append(caseAcronymMeaning)
                }
                
                if variants?.count != 0 {
                    acronymMeaning.variants = variants
                }
            }
            searchResults.append(acronymMeaning)
        }
        return searchResults
    }
}
