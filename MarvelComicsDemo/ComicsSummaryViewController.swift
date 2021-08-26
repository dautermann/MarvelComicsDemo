//
//  ComicsSummaryViewController.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/25/21.
//

import UIKit

/// originally named EntriesViewController with the intention of this being a base class from
/// which we could derive ComicsSummaryViewController, SeriesSummaryViewController, CreatorsSummaryViewController, etc.
/// But for version 1's sake, we'll make this ComicsSummaryViewController from the get go and this can be decoupled
/// as was originally intended in another release.
protocol ComicsSummaryViewUpdating: NSObject {
    func dataSourceUpdated()
}

class ComicsSummaryViewController: UIViewController, UITableViewDelegate, ComicsSummaryViewUpdating {

    @IBOutlet var tableView: UITableView!
    var comicsDataManager: ComicsDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let dataManager = comicsDataManager else {
            fatalError("dataManager not set in prepareForSegue")
        }
        tableView.prefetchDataSource = dataManager
        tableView.dataSource = dataManager
        tableView.delegate = self
    }

    func dataSourceUpdated()
    {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entryToSend = comicsDataManager?.entries[indexPath.item] else { return }
        performSegue(withIdentifier: "ShowComicDetail", sender: entryToSend)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dataManager = comicsDataManager else { return }
        let currentComicsCount = dataManager.entries.count
        let lastElement = currentComicsCount - 1
        if !dataManager.isLoading && indexPath.row == lastElement {
            Swift.print("great time to get more data)")
            dataManager.isLoading = true
            dataManager.getDataFor(typeOfQuery: "comics", startingWith: currentComicsCount)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowComicDetail") {
            // pass data to next view
            if let viewController = segue.destination as? ComicIndividualViewController, let comicEntry = sender as? Comic {
                viewController.comicEntry = comicEntry
            }
        }
    }
}
