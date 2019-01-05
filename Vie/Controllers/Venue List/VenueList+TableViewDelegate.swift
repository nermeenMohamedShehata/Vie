//
//  VenueList+TableViewDelegate.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/4/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
//MARK: - TableViewDelegate & TableViewDataSource
extension VenueListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues?.count ?? 0
    }
    
    func tableView(_ tvareView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableCell", for: indexPath) as! VenueTableCell
        self.configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }
    func configureCell(cell:VenueTableCell, forRowAt indexPath: IndexPath){
        cell.venueNameLabel.text = self.venues![indexPath.row].name
        cell.venueDescriptionLabel.text = self.venues![indexPath.row].venueId
        cell.shareVenue = { [weak self] in
            self?.shareVenue(image: UIImage(named: "sample-photo")!, venueId: self!.venues![indexPath.row].venueId!, venueName:  self!.venues![indexPath.row].name!)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
