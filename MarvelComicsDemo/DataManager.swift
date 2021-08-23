//
//  DataManager.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/15/21.
//

import Foundation
import UIKit

class DataManager: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    func getDataFor(typeOfQuery: String) {
        let timestamp = Date().timeIntervalSinceReferenceDate
        let prehash = "\(timestamp)aa48e821ddcea1b6a1d96a0240cae6e061c9b208ea9d9608aa580d2adfe4ae8afdfc138b"
        guard let queryURL = URL.init(string: "https://gateway.marvel.com:443/v1/public/\(typeOfQuery)?limit=20&ts=\(timestamp)&apikey=ea9d9608aa580d2adfe4ae8afdfc138b&hash=\(prehash.md5())") else {
            return
        }
        var request = URLRequest(url: queryURL)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let actualError = error
            {
                Swift.print("error while talking to marvel API - \(actualError.localizedDescription)")
            }
            guard let responseData = data else {
                // FIXME: Need to throw closure / failure block here
                Swift.print("data is unexpectedly nil")
                return
            }
            
            if (responseData.count > 0) {
                do {
                    if let returnData = String(data: responseData, encoding: .utf8) {
                        Swift.print("responseData is \(returnData)")
                    }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let serverResponse = try decoder.decode(ResponseFromServer.self, from: responseData)
                    Swift.print("number of results is \(serverResponse.data.results.count)")
                } catch let error {
                    Swift.print("error while deserializing category data - \(error)")
                }
            } else {
                Swift.print("no response data to work with")
            }
        }
        task.resume()
    }
    
    private var entries = [Comic]()
}
