//
//  Models.swift
//  FDJ
//
//  Created by Brian Corrieri on 10/10/2019.
//  Copyright © 2019 FairTrip. All rights reserved.
//

import Foundation


struct Teams  : Codable {
    
    struct Team : Codable {
        let strTeam: String
        let strTeamBadge: String
        let idTeam: String
    }
    
    let teams: [Team]
}

struct Leagues  : Codable {
    
    struct League : Codable {
        let strLeague: String
    }
    
    let leagues: [League]
}

struct Players : Codable {
    
    struct Player : Codable {
        let strPlayer: String
        let strPosition: String?
        let dateBorn: String?
        let strSigning: String?
        let strThumb: String?
        let strCutout: String?
    }
    
    let player: [Player]
}
