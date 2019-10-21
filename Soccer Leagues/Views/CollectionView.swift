//
//  CollectionView.swift
//  FDJ
//
//  Created by Brian Corrieri on 10/10/2019.
//  Copyright © 2019 FairTrip. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamResults.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let teamBadgeURL = teamResults[indexPath.row].strTeamBadge + "/preview"
        presenter.getData(urlString: teamBadgeURL) { data in
            if let data = data {
                DispatchQueue.main.async {
                    cell.teamBadge.image = self.decodeImage(data: data)
                }
            }
        }
        cell.teamName.text = teamResults[indexPath.row].strTeam
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.teamID = teamResults[indexPath.row].idTeam
        self.performSegue(withIdentifier: "playersList", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collection.frame.width / 2) - 20
        let height = collection.frame.height / 4
        
        return CGSize(width: width, height: height)
    }
    
    
}
