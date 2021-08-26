//
//  ViewController.swift
//  MarvelComicsDemo
//
//  Created by Michael Dautermann on 8/14/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum QueryType: String, CaseIterable {
        case characters = "characters"
        case comics = "comics"
        case creators = "creators"
        case events = "events"
        case series = "series"
        case stories = "stories"
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /// No separator lines for empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// only one section
        return QueryType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse or create a cell.
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
        dataManager.getDataFor(typeOfQuery: QueryType.allCases[indexPath.row].rawValue, startingWith: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EntriesDetailViewSegue") {
            // pass data to next view
            if let viewController = segue.destination as? ComicsSummaryViewController {
                viewController.comicsDataManager = dataManager
                dataManager.delegate = viewController
            }
        }
    }

    private var dataManager: ComicsDataManager = ComicsDataManager()
}

