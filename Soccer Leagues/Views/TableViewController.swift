//
//  TableViewController.swift
//  FDJ
//
//  Created by Brian Corrieri on 10/10/2019.
//  Copyright © 2019 FairTrip. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    let presenter = Presenter()
    
    var teamID = String()
    var players = [Players.Player]()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        let urlPlayers = "https://www.thesportsdb.com/api/v1/json/1/lookup_all_players.php?id=" + teamID
        presenter.getData(urlString: urlPlayers) { data in
            if let data = data {
                if let players = self.presenter.decodeJSONPlayers(data: data) {
                    self.players = players
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.playerName.text = players[indexPath.row].strPlayer
        cell.playerPosition.text = players[indexPath.row].strPosition
        cell.playerBirthdate.text = "Birth date: " + (players[indexPath.row].dateBorn ?? "")
        cell.playerPrice.text = "Price: " + (players[indexPath.row].strSigning ?? "")
        
        var playerImage = String()
        if let strCutout = players[indexPath.row].strCutout {
            print("cutout \(strCutout)")
        playerImage = strCutout + "/preview"
        } else if let strThumb = players[indexPath.row].strThumb {
        playerImage = strThumb + "/preview"
        }
        presenter.getData(urlString: playerImage) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.playerImage.image = self.decodeImage(data: data)
                }
            }
        }
        cell.playerImage.clipsToBounds = true
        cell.playerImage.layer.cornerRadius = 10
        
        return cell
    }
        
    func decodeImage(data: Data) -> UIImage? {
            guard let image = UIImage(data: data) else {
                print("Error: did not convert data")
                return nil
            }
            return image
        }
    
}



