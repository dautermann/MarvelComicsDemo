//
//  ComicsDataManagerTableViewDataSource.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/27/21.
//

import UIKit
import SDWebImage

extension ComicsDataManager : UITableViewDataSource, UITableViewDataSourcePrefetching {
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
