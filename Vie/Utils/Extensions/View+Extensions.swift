//
//  View+Extensions.swift
//  Joi
//
//  Created by Meseery on 9/18/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit


typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}

extension UIView {
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    
    func addBorder(ofSize size:CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = size
        self.layer.borderColor = color.cgColor
    }
    
    func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    func negativeShake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.fromValue = CGPoint(x: self.center.x - 4, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4, y: self.center.y)
        
        self.layer.add(animation, forKey: "position")
    }
    
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}

extension UIButton {
    func underline() {
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : self.titleLabel!.font,
            NSAttributedString.Key.foregroundColor : self.titleLabel!.textColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: self.title(for: .normal)!,
                                                        attributes: yourAttributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
}

extension UITextField {
    func underline() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}
extension UILabel{
    func textAutoHeight(text: String) -> Int{
        
        self.frame = CGRect(x : self.frame.origin.x,y :self.frame.origin.y,width : self.frame.width ,height : self.heightForView(lbl : self,text: text, width: self.frame.width))
        return  Int(self.frame.height)//
    }
    
    func heightForView(lbl : UILabel ,text:String, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: lbl.frame.origin.x, y: lbl.frame.origin.y, width: lbl.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}


