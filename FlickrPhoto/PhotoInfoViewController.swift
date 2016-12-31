//
//  PhotoInfoViewController.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 26/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import UIKit

class PhotoInfoViewController : UIViewController
{
    @IBOutlet var imageView : UIImageView!
    
    var photo: Photo!
        {
        didSet{
            navigationItem.title = photo.title
        }
    }
    
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoStore.fetchImage(for: photo, completion: {
        
        (result) -> Void in
            
            switch result{
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Errror fetching image :: \(error)")
            }
        
        })
    }
    
}
