//
//  ComicsDataManager.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/25/21.
//

import Foundation
import UIKit
import SDWebImage

/// I originally named this class DataManager with the hopes of subclassing a
/// baseclass to handle the various query types that the Marvel API offers.
/// For this initial release we'll call it ComicsDataManager and try to keep things
/// segmented so the reusable parts can be decoupled beautifully and then
/// we'll have CreatorsDataManager, EventsDataManager, SeriesDataManager, etc.
class ComicsDataManager: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    var entries = [Comic]()

    /// isLoading should ideally be private
    var isLoading = false

    weak var delegate: ComicsSummaryViewUpdating?

    func getData(startingWith: Int) {
        /// this can be turned into a baseclass / decoupled from "comics" by declaring a protocol for the query type in the base class and then
        /// subclasses can implement what kind of query type we'll be using...
        let timestamp = Date().timeIntervalSinceReferenceDate
        let prehash = "\(timestamp)aa48e821ddcea1b6a1d96a0240cae6e061c9b208ea9d9608aa580d2adfe4ae8afdfc138b"
        guard let queryURL = URL.init(string: "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(startingWith)&ts=\(timestamp)&apikey=ea9d9608aa580d2adfe4ae8afdfc138b&hash=\(prehash.md5())") else {
            return
        }
        var request = URLRequest(url: queryURL)

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            /// I could use self? (optional), but let's be strong about it
            guard let self = self else { return }
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
                if let returnData = String(data: responseData, encoding: .utf8) {
                    Swift.print("responseData is \(returnData)")
                }
                if let newEntries = self.parse(data: responseData) {
                    self.entries += newEntries
                }
            } else {
                Swift.print("no response data to work with")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.dataSourceUpdated()
            }
            self.isLoading = false
        }
        task.resume()
    }

    func parse(data: Data) -> [Comic]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        do {
            let serverResponse = try decoder.decode(ResponseFromServer.self, from: data)
            Swift.print("number of results is \(serverResponse.data.results.count); current number of entries is \(self.entries.count)")
            return serverResponse.data.results
        } catch let error {
            Swift.print("error while deserializing category data - \(error)")
            return nil
        }
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entryCell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell

        entryCell.title.text = entries[indexPath.row].title
        entryCell.subtitle.text = entries[indexPath.row].description
        if let thumbnailEntry = entries[indexPath.row].thumbnail, let imageView = entryCell.imageView {
            let thumbnailURLString = thumbnailEntry.wholePath()
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.layer.masksToBounds = true;
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: URL(string: thumbnailURLString), placeholderImage: UIImage(named: "placeholder"),
                options: [], completed: { (_, error, cacheType, url) in
                    /// spent a bit too much time fighting between autolayout and aspect fit/fill, so we'll use an internal
                    /// image for now and circle back and update with something even better
                    if let imageURL = url, imageURL.absoluteString.contains("image_not_available") {
                        imageView.image = UIImage(named: "image_not_available")
                    }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        return entryCell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map({ $0.item })
        let entriesSubarray = indexes.map({ entries[$0]} )
        /// if there isn't a thumbnail available, return a blank string and it will be filtered out
        /// on the next line, when we compactMap the string array into a URL array
        let thumbnailPathsAsStrings = entriesSubarray.map({ $0.thumbnail?.wholePath() ?? "" })
        let thumbnailURLs = thumbnailPathsAsStrings.compactMap { URL(string:$0) }
        SDWebImagePrefetcher.shared.prefetchURLs(thumbnailURLs)
    }
}
