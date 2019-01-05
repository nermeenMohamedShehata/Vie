//
//  MapVC.swift
//  Vie
//
//  Created by Nerneen Mohamed on 12/6/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

import UIKit

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testSearchAPI()
    }

    func testSearchAPI(){
        sharedDataManager.searchVenues(LatLan: "40.7,-74",version: "20180214", onSuccess: { (venues) in
            print(venues?.count)
        }) { (error) in
            print(error)
        }
    }
}

