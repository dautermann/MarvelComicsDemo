//
//  EntryTableViewCell.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/26/21.
//

import UIKit

@objc (EntryTableViewCell)
class EntryTableViewCell : UITableViewCell
{
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }
}

