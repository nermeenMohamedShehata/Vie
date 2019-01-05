//
//  VenueTableCell.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/4/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import UIKit

class VenueTableCell: UITableViewCell {

    @IBOutlet weak var venueDescriptionLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var venueImageView: UIImageView!
    var shareVenue : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        shareVenue!()
    }
    
}
