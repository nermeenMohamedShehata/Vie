//
//  VenueListVC+DeepLink.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/5/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks
//MARK: - DeepLink 
extension VenueListVC{
    //1 - Create DeepLink
    func createVenueShareDeepLinkURL(venueId: String,onComplete: @escaping (URL)->Void) {
        let deeplink =  sharedDataManager.createShareVenueURL(for: venueId)
        let dynamicLinksDomain = AppConstants.dynamicLinksDomain
        let linkBuilder = DynamicLinkComponents(link: deeplink, domain: dynamicLinksDomain)
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.vie.ios")
        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.vie.android")
        guard let longDynamicLink = linkBuilder.url else { return }
        print("The long URL is: \(longDynamicLink)")
        onComplete(longDynamicLink)
    }
    //2 - Share Info & Link with other App
    func shareVenue(image:UIImage,venueId: String,venueName:String){
        self.createVenueShareDeepLinkURL(venueId: venueId) { (url) in
            let vc = UIActivityViewController(activityItems: [venueName,url,image], applicationActivities: [])
            if  let popoverController = vc.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = self.view.bounds
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}
