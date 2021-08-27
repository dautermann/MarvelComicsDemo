//
//  ViewController.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/25/21.
//

import UIKit

class InitialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum QueryType: String, CaseIterable {
        case characters = "characters"
        case comics = "comics"
        case creators = "creators"
        case events = "events"
        case series = "series"
        case stories = "stories"
    }
    
    @IBOutlet var initialTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// No separator lines for empty cells
        self.initialTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// only one section
        return QueryType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// using very basic cell style here
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
        if let textLabel = cell.textLabel {
            let queryString = QueryType.allCases[indexPath.row].rawValue
            textLabel.text = queryString
            /// future versions of this sample app can be expanded to support more (or all) of the possible API queries!
            let isCellEnabled = queryString == "comics"
            cell.selectionStyle = isCellEnabled ? .blue : .none
            textLabel.isEnabled = isCellEnabled
            cell.isUserInteractionEnabled = isCellEnabled
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comicsDataManager.getData(startingWith: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EntriesDetailViewSegue") {
            /// pass data to next view
            if let viewController = segue.destination as? ComicsSummaryViewController {
                viewController.comicsDataManager = comicsDataManager
                comicsDataManager.delegate = viewController
            }
        }
    }

    private var comicsDataManager: ComicsDataManager = ComicsDataManager()
}

