//
//  UIButton+Extensions.swift
//  Joi
//
//  Created by Meseery on 11/5/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit

extension UIButton {
    static var listButton : UIButton {
        let listButton = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 42))
        let image = UIImage(named : "listIcon")
        listButton.setImage(image?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        listButton.imageView?.contentMode = .center
        return listButton
    }
    
   
    
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.imageView,
            let titleLabel = self.titleLabel else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1;
        let imageSize = imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsets(top: (imageSize.height+gap)*sign, left: -imageSize.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.bounds.size;
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height+gap)*sign, left: 0, bottom: 0, right: -titleSize.width);
    }
}
