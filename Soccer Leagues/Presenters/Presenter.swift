//
//  Presenter.swift
//  FDJ
//
//  Created by Brian Corrieri on 10/10/2019.
//  Copyright © 2019 FairTrip. All rights reserved.
//

import Foundation


class Presenter {
    
    var allLeagues = [String]()
    
    func decodeJSONLeagues(data: Data) -> [String]? {
        let decoder = JSONDecoder()
        let leagues = try? decoder.decode(Leagues.self, from: data)
        var allLeagues = [String]()
        
        if let leagues = leagues {
            print("Presenter Leagues \(leagues)")
            for league in leagues.leagues {
                allLeagues.append(league.strLeague)
            }
            self.allLeagues = allLeagues
            return allLeagues
        } else {
            return nil
        }
    }
    
    func decodeJSONTeams(data: Data) -> [Teams.Team]? {
        let decoder = JSONDecoder()
        let teams = try? decoder.decode(Teams.self, from: data)
        
        if let teams = teams {
            return teams.teams
        } else {
            return nil
        }
    }
    
    func decodeJSONPlayers(data: Data) -> [Players.Player]? {
        let decoder = JSONDecoder()
        let players = try? decoder.decode(Players.self, from: data)
        
        if let players = players {
            return players.player
        } else {
            return nil
        }
    }
    
    func getData(urlString: String, completion: @escaping (Data?) -> ()) {
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return completion(nil)
        }
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling getData")
                print(error!)
                return completion(nil)
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return completion(nil)
            }
            
            return completion(responseData)
        }
        task.resume()
        
    }
    
    func updateSearch(searchText: String, completion: @escaping ([Teams.Team]?) -> ()) {
        var results = [String]()
        for league in allLeagues {
            if league.contains(searchText) {
                results.append(league)
            }
        }
        if results.count > 0 {
        let text = results[0].replacingOccurrences(of: " ", with: "%20")
        let urlJSON = "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=" + text
        
           getData(urlString: urlJSON) { data in
            if let data = data {
                if let teams = self.decodeJSONTeams(data: data) {
                    return completion(teams)
                } else { return completion(nil) }
            } else { return completion(nil) }
        }
        } else { return completion(nil) }
    }
    
    
}
