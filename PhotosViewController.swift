//
//  PhotosViewController.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 25/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import UIKit

class PhotosViewController : UIViewController, UICollectionViewDelegate
{
    var photoStore : PhotoStore!
    
   
    @IBOutlet var collectionView: UICollectionView!
    
    let photoDataSource = PhotoDatasource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        
        
        photoStore.fetchInterestingPhotos{
            (photosResult) -> Void in
            
            switch photosResult
            {
            case let .success(photos):
                print("successfully found photos with count:: \(photos.count)")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
            case "showPhoto"?:
            
                if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first{
                    let photo = photoDataSource.photos[selectedIndexPath.row]
                
                    let destinationVC = segue.destination as! PhotoInfoViewController
                    
                    destinationVC.photo = photo
                    destinationVC.photoStore = photoStore
            }
        default:
            preconditionFailure("Unexpected seque identifier")
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let photo = photoDataSource.photos[indexPath.row]
        
        photoStore.fetchImage(for: photo, completion: {
        
            (photoResult) -> Void in
            
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = photoResult else { return}
            
            let photoIndexPath = IndexPath(row: photoIndex, section: 0)
            
           if let cell = collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell
           {
            cell.update(with: image)
            }
            
        
        
        
        })
    }
}
