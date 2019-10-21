//
//  ViewController.swift
//  FDJ
//
//  Created by Brian Corrieri on 10/10/2019.
//  Copyright © 2019 FairTrip. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var collection: UICollectionView!
    
    let presenter = Presenter()
    
    let searchController = UISearchController(searchResultsController: nil)
    var allLeagues = [String]()
    var teamResults = [Teams.Team]()
    var teamID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = "Search for soccer league" 
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        let urlJSON2 = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php"
        presenter.getData(urlString: urlJSON2) { data in
            if let data = data {
                if let leagues = self.presenter.decodeJSONLeagues(data: data) {
                    self.allLeagues = leagues
                }
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            presenter.updateSearch(searchText: searchText) { teams in
                if let teams = teams {
                    self.teamResults = teams
                    DispatchQueue.main.async {
                    self.collection.reloadData()
                    }
                }
            }
        }
        
    }
    
    func decodeImage(data: Data) -> UIImage? {
        guard let image = UIImage(data: data) else {
            print("Error: did not convert data")
            return nil
        }
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TableViewController {
            vc.teamID = self.teamID
        }
    }
}





