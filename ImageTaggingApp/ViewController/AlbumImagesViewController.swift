//
//  AlbumImagesViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 25.01.22.
//

import Foundation
import UIKit

class AlbumImagesViewController: UICollectionViewController {
    var images: [Image]?
    
    let reuseIdentifier = "ImageCell"
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 0,
        right: 0)
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (images!.count / 3) + 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! ImageCollectionViewCell
        
        let image = UIImage(data: images![indexPath.section].storedImage!)
        cell.imageView.image = image
        
        return cell
    }
}

extension AlbumImagesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let availableWidth = view.frame.width
    let widthPerItem = availableWidth
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
}
