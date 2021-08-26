//
//  ComicIndividualViewController.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/26/21.
//

import UIKit

class ComicIndividualViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!

    /// something else we could do is create a table or collection view so **all**
    /// useful, user-readable elements of a comic entry could be displayed and
    /// scrolled up and down
    @IBOutlet var comicTitle: UILabel!
    @IBOutlet var comicDescription: UITextView!
    var comicEntry: Comic?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let comicEntry = comicEntry else { return }

        if let imageWholePath = comicEntry.images?[0].wholePath() {
            imageView.sd_setImage(with: URL(string: imageWholePath), placeholderImage: UIImage(named: "placehodler"), options: [], completed: { (_, error, cacheType, url) in
                /// spent too much time fighting between autolayout and aspect fit/fill, so we'll use an internal
                /// image for now and circle back and update with something even better
                if let imageURL = url, imageURL.absoluteString.contains("image_not_available") {
                    self.imageView.image = UIImage(named: "image_not_available")
                }
            })
        }
        comicTitle.text = comicEntry.title
        comicDescription.text = comicEntry.description
    }
    
}
