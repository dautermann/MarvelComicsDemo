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
            textLabel.text = QueryType.allCases[indexPath.row].rawValue
        }

       // cell.imageView!.image = UIImage(named: "bunny")
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Swift.print("indexPath \(indexPath.row) selected")
        
        let dataManager = DataManager()
        dataManager.getDataFor(typeOfQuery: QueryType.allCases[indexPath.row].rawValue)
    }
    
}

