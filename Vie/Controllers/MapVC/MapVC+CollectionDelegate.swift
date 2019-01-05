//
//  MapVC+CollectionDelegate.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/4/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
//MARK: - CollectionViewDelegate  & CollectionViewDataSource
extension MapVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionCell", for: indexPath) as! VenueCollectionCell
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }
    func configureCell(cell:VenueCollectionCell, forRowAt indexPath: IndexPath){
        cell.venueNameLabel.text = self.venues![indexPath.row].name
        cell.venueDescriptionLabel.text = "Venu Indx = \(self.venues![indexPath.row].index)"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.venues?.count ?? 0
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension MapVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
  

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateOffset(scrollView: scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentIndex = Int(scrollView.contentOffset.x / self.collectionView.frame.size.width)
        isDragCollectionview = true
        currentIndex = self.scrollDir == UISwipeGestureRecognizer.Direction.right ? currentIndex + 1 : currentIndex - 1
        self.selectVenueOnMap(indexPath:currentIndex)
    }
    func calculateOffset(scrollView: UIScrollView){
        if (self.lastContentOffset > scrollView.contentOffset.x)
        {
            self.scrollDir = UISwipeGestureRecognizer.Direction.left
        }
        else if (self.lastContentOffset < scrollView.contentOffset.x)
        {
            self.scrollDir = UISwipeGestureRecognizer.Direction.right
        }
        self.lastContentOffset = scrollView.contentOffset.x;
    }
}
extension MapVC{
    
    func selectVenueOnMap(indexPath:Int){
        guard indexPath > 0,indexPath < (self.venues?.count)! else{return}
        let annotations = self.mapView.annotations as! [VenueAnnotation]
        let annotation =   annotations.first(where: {$0.venue.venueId! == self.venues![(indexPath)].venueId})
        self.mapView.selectAnnotation(annotation!, animated: true)
    }
}
