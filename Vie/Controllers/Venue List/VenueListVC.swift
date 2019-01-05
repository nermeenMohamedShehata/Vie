//
//  VenueListVC.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/4/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
class VenueListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var venues : [Venue]? {
        didSet{
            DispatchQueue.main.async {
                for i in 0..<(self.venues?.count)!{
                    self.venues![i].index = i
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    func setupViews(){
        setupNavigationBar()
    }
    func setupNavigationBar()  {
        self.navigationItem.hidesBackButton = true;
        let listButton = UIButton.listButton
        listButton.addTarget(self, action: #selector(didTapOpenMap(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listButton)
    }
    @objc func didTapOpenMap(_ sender:UIBarButtonItem )  {
        self.navigationController?.popViewController(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    deinit {
        self.venues?.removeAll()
       
    }
}
